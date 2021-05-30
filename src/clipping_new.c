#include <presto.h>
#include <immintrin.h>
#include "float.h"

#define BLOCKSTOSKIP 100
#define inf 1.0e100

int read_onoff_paris(FILE * onofffile, long long **onbins, long long **offbins)
// Read a text file containing rows of ASCII pairs of integers
// corresponding to where clipping should be on or off 
// The format for a line is: "CLIPON:CLIPOFF" with 0 indexing
// Lines beginning with '#' are ignored.
{
    char line[200], *sptr = NULL;
    int ii, numpairs;

    /* Read the input file once to count pairs */
    numpairs = 0;
    while (!feof(onofffile)) {
        sptr = fgets(line, 200, onofffile);
        if (sptr != NULL && sptr[0] != '\n') {
            if (line[0] == '#')
                continue;

            else
                numpairs++;
        }
    }
    *onbins = (long long *) malloc(sizeof(long long) * numpairs);
    *offbins = (long long *) malloc(sizeof(long long) * numpairs);

    /* Rewind and read the pairs for real */
    rewind(onofffile);
    ii = 0;
    while (ii < numpairs) {
        sptr = fgets(line, 200, onofffile);
        if (sptr != NULL && sptr[0] != '\n') {
            if (line[0] == '#')
                continue;

            else {
                sscanf(line, "%lld:%lld\n", &(*onbins)[ii], &(*offbins)[ii]);
                ii++;
            }
        }
    }
    return numpairs;
}

/*
lqq: test cmd
prepsubband -sub -subdm 44.52 -nsub 32 -downsamp 1 -o Sband ../J0631+4147_tracking_0001.fits
prepsubband -nsub 32 -lodm 44.000000 -dmstep 0.050000 -numdms 22 -numout 131000 -downsamp 1 -o Sband Sband_DM44.52.sub[0-9]*
*/

/* NEW Clipping Routine (uses channel running averages and reuse array avoid heavy copy) */
int clip_times(float *rawdata, int ptsperblk, int numchan, float clip_sigma,
               float *good_chan_levels)
// Perform time-domain clipping of rawdata.  This is a 2D array with
// ptsperblk*numchan points, each of which is a float.  The clipping
// is done at clip_sigma sigma above/below the running mean.  The
// up-to-date running averages of the channels are returned in
// good_chan_levels (which must be pre-allocated).
{
    // printf("new clip_times\n");
    // printf("numchan: %d\n", numchan);
    if (numchan & 0xf) {
        printf("fuck numchan: %d\n", numchan);
    }
    static float *chan_running_avg;
    static float running_avg = 0.0, running_std = 0.0;
    static int blocksread = 0, firsttime = 1;
    static long long current_point = 0;
    static int numonoff = 0, onoffindex = 0;
    static long long *onbins = NULL, *offbins = NULL;
    // static int rh_count = 0;
    // static int *rh_bad;
    static float exchange_tmp;
    float *zero_dm_block, *raw_zero_dm_block, *ftmp, *powptr;
    float biggest_zero_dm_blk, smallest_zero_dm_blk;
    float *chan_avg_temp;
    float current_med, trigger;
    double current_avg = 0.0, current_std = 0.0;
    int ii, jj, clipit = 0, clipped = 0;
    if (firsttime) {
        chan_running_avg = gen_fvect(numchan);
        // rh_bad = malloc(size(int)*ptsperblk/5); // remain 10% of bad points
        firsttime = 0;
        {                       // This is experimental code to zap radar-filled data
            char *envval = getenv("CLIPBINSFILE");
            if (unlikely(envval != NULL)) {
                FILE *onofffile = chkfopen(envval, "r");
                numonoff = read_onoff_paris(onofffile, &onbins, &offbins);
                fclose(onofffile);
                printf("\nRead %d bin clipping pairs from '%s'.\n", numonoff,
                       envval);

                //for (ii=0;ii<numonoff;ii++) printf("%lld %lld\n", onbins[ii], offbins[ii]);
            }
        }
    }

    // each block has ptsperblk points, each points has numchan rawdata
    // zero_dm_block records the sum of numchan rawdata of each points
    // chan_avg_temp 
    // rh_count = 0;
    chan_avg_temp = gen_fvect(numchan);
    zero_dm_block = gen_fvect(ptsperblk); 
    raw_zero_dm_block = gen_fvect(ptsperblk); 
    ftmp = gen_fvect(ptsperblk);
    biggest_zero_dm_blk = -inf;
    smallest_zero_dm_blk = inf;

    #pragma simd
    #pragma vector aligned
    for (jj = 0; jj < numchan; jj++) {
        chan_avg_temp[jj] = 0.0;
    }

    // __m512 _zero = _mm512_setzero_ps();
    /* Calculate the zero DM time series */
    for (ii = 0; ii < ptsperblk; ii++) {
        zero_dm_block[ii] = 0.0;
        powptr = rawdata + ii * numchan;
#if 0
        __m512 _tmp;
        __m512 _sum = _zero;
        for (jj = 0; jj < numchan; jj += 16) {
            _tmp = _mm512_load_ps(powptr + jj);
            _sum = _sum + _tmp;
            _tmp = _tmp + _mm512_load_ps(chan_avg_temp + jj);
            _mm512_store_ps(chan_avg_temp + jj, _tmp);
        }
        zero_dm_block[ii]  = _mm512_reduce_add_ps(_sum);
#else
        for (jj = 0; jj < numchan; jj ++) {
            zero_dm_block[ii] += *powptr;
            chan_avg_temp[jj] += *powptr++;
        }
#endif

        if (zero_dm_block[ii] > biggest_zero_dm_blk) {
            biggest_zero_dm_blk = zero_dm_block[ii];
        }
        if (zero_dm_block[ii] < smallest_zero_dm_blk) {
            smallest_zero_dm_blk = zero_dm_block[ii];
        }
        // printf("[lqq] %f big:%f small:%f\n", zero_dm_block[ii], biggest_zero_dm_blk, smallest_zero_dm_blk);
        ftmp[ii] = zero_dm_block[ii];
        raw_zero_dm_block[ii] = zero_dm_block[ii];
    }

    // printf("[lqq] max:%f min:%f\n", biggest_zero_dm_blk, smallest_zero_dm_blk);

    // for (ii = 0; ii < ptsperblk; ii++) {
    //     printf("[lqq] %f\n", zero_dm_block[ii]);
    // }
    // for (jj = 0; jj < numchan; jj ++) {
    //     printf("[lqq] %f\n", chan_avg_temp[jj]);
    // }

    // calculate the avg and std of zero_dm_block
    // since it will exchange the order of zero_dm_block in median()
    //     therefore the corresponding index will be disordered, so use ftmp
    avg_var(ftmp, ptsperblk, &current_avg, &current_std);
    current_std = sqrt(current_std);
    current_med = median(ftmp, ptsperblk);

    /* Calculate the current standard deviation and mean  */
    /* but only for data points that are within a certain */
    /* fraction of the median value.  This removes the    */
    /* really strong RFI from the calculation.            */
    {
        float lo_cutoff, hi_cutoff;
        int numgoodpts = 0;
        lo_cutoff = current_med - 3.0 * current_std;
        hi_cutoff = current_med + 3.0 * current_std;
        // printf("\nlo_cutoff:%f hi_cutoff:%f current_med:%f current_std:%f\n", lo_cutoff, hi_cutoff, current_med, current_std);

        // if fabs(current_std) <= DBL_EPSILON, that numgoodpts = 0, chan_avg_temp will be overwritten
        if (fabs(current_std) > DBL_EPSILON) {
            /* Delete the "bad" points */
            float* lhs = zero_dm_block;
            float* rhs = zero_dm_block + ptsperblk - 1;
            
            while (lhs != rhs) {
                while (lhs != rhs && *lhs > lo_cutoff && *lhs < hi_cutoff) {
                    lhs ++; // find a good point, continue
                }
                while (lhs != rhs && (*rhs < lo_cutoff || *rhs > hi_cutoff)) {
                    powptr = rawdata + (lhs - zero_dm_block) * numchan;
                    #pragma simd
                    #pragma vector aligned
                    for (jj = 0; jj < numchan; jj++)
                        chan_avg_temp[jj] -= *powptr++;
                    rhs --; // find a bad point, continue
                }
                if (lhs != rhs) {
                    // exchange good and bad point
                    exchange_tmp = *lhs;
                    // printf("lhs:%x rhs:%x\n", lhs, rhs);
                    // printf("*lhs:%f *rhs:%f\n", *lhs, *rhs);
                    *lhs = *rhs;
                    *rhs = exchange_tmp;
                } else {
                    numgoodpts = lhs - zero_dm_block;
                    // determine whether this point is bad point
                    if ((*lhs > lo_cutoff && *lhs < hi_cutoff)) {
                        // it is good point
                        numgoodpts ++;
                    } else {
                        /*
                            situation1: lhs -> rhs && rhs is bad point
                            situation2: lhs -> mid_left && rhs -> mid_left && mid_left is bad point
                            situation3: lhs -> mid_left && rhs -> mid_right |> exchange and lhs -> mid_right
                        */
                        powptr = rawdata + (lhs - zero_dm_block) * numchan;
                        #pragma simd
                        #pragma vector aligned
                        for (jj = 0; jj < numchan; jj++)
                            chan_avg_temp[jj] -= *powptr++;
                    }
                    break;
                }
            }
        }

        //printf("avg = %f  med = %f  std = %f  numgoodpts = %d\n", 
        //       current_avg, current_med, current_std, numgoodpts);

        /* Calculate the current average and stddev */
        if (numgoodpts < 1) {
            current_avg = running_avg;
            current_std = running_std;
            for (jj = 0; jj < numchan; jj++)
                chan_avg_temp[jj] = chan_running_avg[jj];
        } else {
            avg_var(zero_dm_block, numgoodpts, &current_avg, &current_std);
            current_std = sqrt(current_std);
            for (jj = 0; jj < numchan; jj++)
                chan_avg_temp[jj] /= numgoodpts;
        }
    } 

    // printf("\n[lqq] ");
    // for (jj = 0; jj < numchan; jj++)
    //     printf("%f ", chan_avg_temp[jj]);
    // putchar(10);

    /* Update a pseudo running average and stdev */
    if (blocksread) {
        running_avg = 0.9 * running_avg + 0.1 * current_avg;
        running_std = 0.9 * running_std + 0.1 * current_std;
        #pragma simd
        #pragma vector aligned
        for (ii = 0; ii < numchan; ii++) {
            chan_running_avg[ii] =
                0.9 * chan_running_avg[ii] + 0.1 * chan_avg_temp[ii];
            good_chan_levels[ii] = chan_running_avg[ii];
        }
    } else {
        running_avg = current_avg;
        running_std = current_std;
        #pragma simd
        #pragma vector aligned
        for (ii = 0; ii < numchan; ii++) {
            chan_running_avg[ii] = chan_avg_temp[ii];
            good_chan_levels[ii] = chan_running_avg[ii];
        }
        if (current_avg == 0.0)
            printf("Warning:  problem with clipping in first block!!!\n\n");
    }

    // printf("[lqq] chan_running_avg: ");
    // for (ii = 0; ii < numchan; ii++) {
    //     printf("%f ", chan_running_avg[ii]);
    // }
    // printf("\n");


    /* See if any points need clipping */
    trigger = clip_sigma * running_std;
    // for (ii = 0; ii < ptsperblk; ii++) {
    //     if (fabs(zero_dm_block[ii] - running_avg) > trigger) {
    //         clipit = 1;
    //         break;
    //     }
    // }
    if ((fabs(biggest_zero_dm_blk - running_avg) > trigger || fabs(smallest_zero_dm_blk - running_avg) > trigger)) {
        clipit = 1;
    }

    /* or alternatively from the CLIPBINSFILE */
    if (!clipit && numonoff && ((current_point > onbins[onoffindex]
                      && current_point <= offbins[onoffindex])
                     || (current_point + ptsperblk > onbins[onoffindex]
                         && current_point + ptsperblk <= offbins[onoffindex])
                     || (current_point < onbins[onoffindex]
                         && current_point + ptsperblk > offbins[onoffindex]))) {
        clipit = 1;
    }

    /* Update the good channel levels */
    // for (ii = 0; ii < numchan; ii++)
    //     good_chan_levels[ii] = chan_running_avg[ii];

    /* Replace the bad channel data with channel median values */
    /* that are scaled to equal the running_avg.               */
    if (clipit) {
        for (ii = 0; ii < ptsperblk; ii++) {
            if ((fabs(raw_zero_dm_block[ii] - running_avg) > trigger) ||
                (numonoff && (current_point > onbins[onoffindex]
                              && current_point <= offbins[onoffindex]))) {
                powptr = rawdata + ii * numchan;
                for (jj = 0; jj < numchan; jj++)
                    *powptr++ = good_chan_levels[jj];
                clipped++;

                //fprintf(stderr, "zapping %lld\n", current_point);
            }
            current_point++;
            if (numonoff && current_point > offbins[onoffindex]
                && onoffindex < numonoff - 1) {
                while (current_point > offbins[onoffindex]
                       && onoffindex < numonoff - 1) {
                    onoffindex++;
                }
                
                //printf("updating index to %d\n", onoffindex);
            }
        }
    } else {
        current_point += ptsperblk;
        if (numonoff && current_point > offbins[onoffindex]
            && onoffindex < numonoff - 1) {
            while (current_point > offbins[onoffindex]
                   && onoffindex < numonoff - 1) {
                onoffindex++;
            }

            //printf("updating index to %d\n", onoffindex);
        }
    }
    blocksread++;
    vect_free(chan_avg_temp);
    vect_free(zero_dm_block);
    vect_free(raw_zero_dm_block);
    vect_free(ftmp);
    return clipped;
}

/* ORIGINAL Clipping Routine (uses channel running averages but regenerate array each time) */
int old_clip_times(float *rawdata, int ptsperblk, int numchan, float clip_sigma,
               float *good_chan_levels)
// Perform time-domain clipping of rawdata.  This is a 2D array with
// ptsperblk*numchan points, each of which is a float.  The clipping
// is done at clip_sigma sigma above/below the running mean.  The
// up-to-date running averages of the channels are returned in
// good_chan_levels (which must be pre-allocated).
{
    // printf("original clip_times\n");
    static float *chan_running_avg;
    static float running_avg = 0.0, running_std = 0.0;
    static int blocksread = 0, firsttime = 1;
    static long long current_point = 0;
    static int numonoff = 0, onoffindex = 0;
    static long long *onbins = NULL, *offbins = NULL;
    float *zero_dm_block, *ftmp, *powptr;
    double *chan_avg_temp;
    float current_med, trigger;
    double current_avg = 0.0, current_std = 0.0;
    int ii, jj, clipit = 0, clipped = 0;
    if (firsttime) {
        chan_running_avg = gen_fvect(numchan);
        firsttime = 0;
        {                       // This is experimental code to zap radar-filled data
            char *envval = getenv("CLIPBINSFILE");
            if (unlikely(envval != NULL)) {
                FILE *onofffile = chkfopen(envval, "r");
                numonoff = read_onoff_paris(onofffile, &onbins, &offbins);
                fclose(onofffile);
                printf("\nRead %d bin clipping pairs from '%s'.\n", numonoff,
                       envval);

                //for (ii=0;ii<numonoff;ii++) printf("%lld %lld\n", onbins[ii], offbins[ii]);
            }
        }
    }
    chan_avg_temp = gen_dvect(numchan);
    zero_dm_block = gen_fvect(ptsperblk);
    ftmp = gen_fvect(ptsperblk);

    /* Calculate the zero DM time series */
    for (ii = 0; ii < ptsperblk; ii++) {
        zero_dm_block[ii] = 0.0;
        powptr = rawdata + ii * numchan;
        for (jj = 0; jj < numchan; jj++)
            zero_dm_block[ii] += *powptr++;
        ftmp[ii] = zero_dm_block[ii];
    }

    avg_var(ftmp, ptsperblk, &current_avg, &current_std);
    current_std = sqrt(current_std);
    current_med = median(ftmp, ptsperblk);

    /* Calculate the current standard deviation and mean  */
    /* but only for data points that are within a certain */
    /* fraction of the median value.  This removes the    */
    /* really strong RFI from the calculation.            */
    {
        float lo_cutoff, hi_cutoff;
        int numgoodpts = 0;
        lo_cutoff = current_med - 3.0 * current_std;
        hi_cutoff = current_med + 3.0 * current_std;

        printf("\nlo_cutoff:%f hi_cutoff:%f current_med:%f current_std:%f\n", lo_cutoff, hi_cutoff, current_med, current_std);

        #pragma simd
        #pragma vector aligned
        for (jj = 0; jj < numchan; jj++)
            chan_avg_temp[jj] = 0.0;

        /* Find the "good" points */
        for (ii = 0; ii < ptsperblk; ii++) {
            if (zero_dm_block[ii] > lo_cutoff && zero_dm_block[ii] < hi_cutoff) {
                ftmp[numgoodpts] = zero_dm_block[ii];
                powptr = rawdata + ii * numchan;
                #pragma simd
                #pragma vector aligned
                for (jj = 0; jj < numchan; jj++)
                    chan_avg_temp[jj] += *powptr++;
                numgoodpts++;
            }
        }
        // printf("[lqq] cliptimes goodnum:%d ptsperblk:%d\n", numgoodpts, ptsperblk);

        //printf("avg = %f  med = %f  std = %f  numgoodpts = %d\n", 
        //       current_avg, current_med, current_std, numgoodpts);

        /* Calculate the current average and stddev */
        if (numgoodpts < 1) {
            current_avg = running_avg;
            current_std = running_std;
            for (jj = 0; jj < numchan; jj++)
                chan_avg_temp[jj] = chan_running_avg[jj];
        } else {
            avg_var(ftmp, numgoodpts, &current_avg, &current_std);
            current_std = sqrt(current_std);
            for (jj = 0; jj < numchan; jj++)
                chan_avg_temp[jj] /= numgoodpts;
        }
    }

    /* Update a pseudo running average and stdev */
    if (blocksread) {
        running_avg = 0.9 * running_avg + 0.1 * current_avg;
        running_std = 0.9 * running_std + 0.1 * current_std;
        for (ii = 0; ii < numchan; ii++)
            chan_running_avg[ii] =
                0.9 * chan_running_avg[ii] + 0.1 * chan_avg_temp[ii];
    } else {
        running_avg = current_avg;
        running_std = current_std;
        for (ii = 0; ii < numchan; ii++)
            chan_running_avg[ii] = chan_avg_temp[ii];
        if (current_avg == 0.0)
            printf("Warning:  problem with clipping in first block!!!\n\n");
    }

    printf("[lqq] chan_running_avg: ");
    for (ii = 0; ii < numchan; ii++) {
        printf("%f ", chan_running_avg[ii]);
    }
    printf("\n");

    /* See if any points need clipping */
    trigger = clip_sigma * running_std;
    for (ii = 0; ii < ptsperblk; ii++) {
        if (fabs(zero_dm_block[ii] - running_avg) > trigger) {
            clipit = 1;
            break;
        }
    }

    /* or alternatively from the CLIPBINSFILE */
    if (numonoff && ((current_point > onbins[onoffindex]
                      && current_point <= offbins[onoffindex])
                     || (current_point + ptsperblk > onbins[onoffindex]
                         && current_point + ptsperblk <= offbins[onoffindex])
                     || (current_point < onbins[onoffindex]
                         && current_point + ptsperblk > offbins[onoffindex])))
        clipit = 1;

    /* Update the good channel levels */
    for (ii = 0; ii < numchan; ii++)
        good_chan_levels[ii] = chan_running_avg[ii];

    /* Replace the bad channel data with channel median values */
    /* that are scaled to equal the running_avg.               */
    if (clipit) {
        for (ii = 0; ii < ptsperblk; ii++) {
            if ((fabs(zero_dm_block[ii] - running_avg) > trigger) ||
                (numonoff && (current_point > onbins[onoffindex]
                              && current_point <= offbins[onoffindex]))) {
                powptr = rawdata + ii * numchan;
                for (jj = 0; jj < numchan; jj++)
                    *powptr++ = good_chan_levels[jj];
                clipped++;

                //fprintf(stderr, "zapping %lld\n", current_point);
            }
            current_point++;
            if (numonoff && current_point > offbins[onoffindex]
                && onoffindex < numonoff - 1) {
                while (current_point > offbins[onoffindex]
                       && onoffindex < numonoff - 1)
                    onoffindex++;

                //printf("updating index to %d\n", onoffindex);
            }
        }
    } else {
        current_point += ptsperblk;
        if (numonoff && current_point > offbins[onoffindex]
            && onoffindex < numonoff - 1) {
            while (current_point > offbins[onoffindex]
                   && onoffindex < numonoff - 1)
                onoffindex++;

            //printf("updating index to %d\n", onoffindex);
        }
    }
    blocksread++;
    vect_free(chan_avg_temp);
    vect_free(zero_dm_block);
    vect_free(ftmp);
    return clipped;
}

/* OLD OLD Clipping Routine (uses channel medians) */
int old_old_clip_times(float *rawdata, int ptsperblk, int numchan, float clip_sigma,
                   float *good_chan_levels)
// Perform time-domain clipping of rawdata.  This is a 2D array with
// ptsperblk*numchan points, each of which is a float.  The clipping
// is done at clip_sigma sigma above/below the running mean.  The
// up-to-date running averages of the channels are returned in
// good_chan_levels (which must be pre-allocated).
{
    static float *median_chan_levels;
    static float running_avg = 0.0, running_std = 0.0, median_sum = 0.0;
    static int blocksread = 0, firsttime = 1;
    float *zero_dm_block, *median_temp;
    float current_med, trigger, running_wgt = 0.05;
    double current_avg = 0.0, current_std = 0.0, scaling;
    float *powptr;
    int ii, jj, clipit = 0, clipped = 0;
    if (firsttime) {
        median_chan_levels = gen_fvect(numchan);
        firsttime = 0;
    }
    zero_dm_block = gen_fvect(ptsperblk);
    median_temp = gen_fvect(ptsperblk);

    /* Calculate the zero DM time series */
    for (ii = 0; ii < ptsperblk; ii++) {
        zero_dm_block[ii] = 0.0;
        powptr = rawdata + ii * numchan;
        for (jj = 0; jj < numchan; jj++)
            zero_dm_block[ii] += *powptr++;
        median_temp[ii] = zero_dm_block[ii];
    }
    current_med = median(median_temp, ptsperblk);

    /* Calculate the current standard deviation and mean  */
    /* but only for data points that are within a certain */
    /* fraction of the median value.  This removes the    */
    /* really strong RFI from the calculation.            */
    {
        float lo_cutoff, hi_cutoff;
        int numgoodpts = 0;
        lo_cutoff = 0.7 * current_med;
        hi_cutoff = 1.3 * current_med;

        /* Find the "good" points */
        for (ii = 0; ii < ptsperblk; ii++) {
            if (zero_dm_block[ii] > lo_cutoff && zero_dm_block[ii] < hi_cutoff) {
                median_temp[numgoodpts] = zero_dm_block[ii];
                numgoodpts++;
            }
        }

        /* Calculate the current average and stddev */
        if (numgoodpts < 1) {
            current_avg = running_avg;
            current_std = running_std;
        } else {
            avg_var(median_temp, numgoodpts, &current_avg, &current_std);
            current_std = sqrt(current_std);
        }
    }

    /* Update a pseudo running average and stdev */
    if (blocksread) {
        running_avg =
            (running_avg * (1.0 - running_wgt) + running_wgt * current_avg);
        running_std =
            (running_std * (1.0 - running_wgt) + running_wgt * current_std);
    } else {
        running_avg = current_avg;
        running_std = current_std;
        if (running_avg == 0.0 || current_avg == 0.0)
            printf("BAD RFI IN BLOCK#1!!!\n\n");
    }

    /* See if any points need clipping */
    trigger = clip_sigma * running_std;
    for (ii = 0; ii < ptsperblk; ii++) {
        if (fabs(zero_dm_block[ii] - running_avg) > trigger) {
            clipit = 1;
            break;
        }
    }

    /* Calculate the channel medians if required */
    if ((blocksread % BLOCKSTOSKIP == 0 && clipit == 0) || blocksread == 0) {
        median_sum = 0.0;
        for (ii = 0; ii < numchan; ii++) {
            powptr = rawdata + ii;
            for (jj = 0; jj < ptsperblk; jj++)
                median_temp[jj] = *(powptr + jj * numchan);
            median_chan_levels[ii] = median(median_temp, ptsperblk);
            median_sum += median_chan_levels[ii];
        }
    }

    /* Update the good channel levels */
    scaling = running_avg / median_sum;
    for (ii = 0; ii < numchan; ii++)
        good_chan_levels[ii] = median_chan_levels[ii] * scaling;

    /* Replace the bad channel data with channel median values */
    /* that are scaled to equal the running_avg.               */
    if (clipit) {
        for (ii = 0; ii < ptsperblk; ii++) {
            if (fabs(zero_dm_block[ii] - running_avg) > trigger) {
                powptr = rawdata + ii * numchan;
                for (jj = 0; jj < numchan; jj++)
                    *powptr++ = good_chan_levels[jj];
                clipped++;
            }
        }
    }
    blocksread++;
    vect_free(zero_dm_block);
    vect_free(median_temp);
    return clipped;
}
