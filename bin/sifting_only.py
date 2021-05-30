#!/home/lqq/presto_with_all_lib/venv/bin/python
# -*- coding: utf-8 -*-

"""
A simple pipelien for demostrating presto
Weiwei Zhu
2015-08-14
Max-Plank Institute for Radio Astronomy
zhuwwpku@gmail.com
"""
import os, sys, glob, re, time
from presto import sifting
from commands import getoutput
from operator import itemgetter, attrgetter
import numpy as np
from multiprocessing import Pool

rootname = 'Sband'
maxDM = 80 #max DM to search
Nsub = 32 #32 subbands
Nint = 64 #64 sub integration
Tres = 0.5 #ms
zmax = 0

filename = sys.argv[1]
if len(sys.argv) > 2:
    maskfile = sys.argv[2]
else:
    maskfile = None

def write_fold_log(msg):
    logfile = open('folding.log', 'w')
    logfile.write("\n".join(msg))
    logfile.close()

def batch_prepfold(fold):
    st = time.time()
    print(fold)
    output = getoutput(fold)
    ed = time.time()
    ttime = "single_fold_time: %f" % (ed - st)
    print(ttime)
    return output

def ACCEL_sift(zmax):
    '''
    The following code come from PRESTO's ACCEL_sift.py
    '''

    globaccel = "*ACCEL_%d" % zmax
    globinf = "*DM*.inf"
    # In how many DMs must a candidate be detected to be considered "good"
    min_num_DMs = 2
    # Lowest DM to consider as a "real" pulsar
    low_DM_cutoff = 2.0
    # Ignore candidates with a sigma (from incoherent power summation) less than this
    sifting.sigma_threshold = 4.0
    # Ignore candidates with a coherent power less than this
    sifting.c_pow_threshold = 100.0

    # If the birds file works well, the following shouldn't
    # be needed at all...  If they are, add tuples with the bad
    # values and their errors.
    #                (ms, err)
    sifting.known_birds_p = []
    #                (Hz, err)
    sifting.known_birds_f = []

    # The following are all defined in the sifting module.
    # But if we want to override them, uncomment and do it here.
    # You shouldn't need to adjust them for most searches, though.

    # How close a candidate has to be to another candidate to                
    # consider it the same candidate (in Fourier bins)
    sifting.r_err = 1.1
    # Shortest period candidates to consider (s)
    sifting.short_period = 0.0005
    # Longest period candidates to consider (s)
    sifting.long_period = 15.0
    # Ignore any candidates where at least one harmonic does exceed this power
    sifting.harm_pow_cutoff = 8.0

    #--------------------------------------------------------------

    # Try to read the .inf files first, as _if_ they are present, all of
    # them should be there.  (if no candidates are found by accelsearch
    # we get no ACCEL files...
    inffiles = glob.glob(globinf)
    candfiles = glob.glob(globaccel)
    # Check to see if this is from a short search
    if len(re.findall("_[0-9][0-9][0-9]M_" , inffiles[0])):
        dmstrs = [x.split("DM")[-1].split("_")[0] for x in candfiles]
    else:
        dmstrs = [x.split("DM")[-1].split(".inf")[0] for x in inffiles]
    dms = map(float, dmstrs)
    dms.sort()
    dmstrs = ["%.2f"%x for x in dms]

    # Read in all the candidates
    cands = sifting.read_candidates(candfiles)

    # Remove candidates that are duplicated in other ACCEL files
    if len(cands):
        cands = sifting.remove_duplicate_candidates(cands)

    # Remove candidates with DM problems
    if len(cands):
        cands = sifting.remove_DM_problems(cands, min_num_DMs, dmstrs, low_DM_cutoff)

    # Remove candidates that are harmonically related to each other
    # Note:  this includes only a small set of harmonics
    if len(cands):
        cands = sifting.remove_harmonics(cands)

    # Write candidates to STDOUT
    if len(cands):
        cands.sort(key=attrgetter("sigma"), reverse=True)
        #for cand in cands[:1]:
            #print cand.filename, cand.candnum, cand.p, cand.DMstr
        #sifting.write_candlist(cands)
    return cands

if __name__=="__main__":

    print("this is sifting and folding only")    

    ss = time.time()

    print '''

    ================sifting candidates==================

    '''

    #try:
    cwd = os.getcwd()
    os.chdir('subbands')
    cands = ACCEL_sift(zmax)
    os.chdir(cwd)
    #except:
        #print 'failed at sifting candidates.'
        #os.chdir(cwd)
        #sys.exit(0)


    ee = time.time()
    print('sifting candidates time_cost: ', ee - ss)

    ss = time.time()

    print '''

    ================folding candidates==================

    '''

    try:
        cwd = os.getcwd()
        os.chdir('subbands')
        os.system('ln -s ../%s %s' % (filename, filename))

        prepfold_cmd = []
        dm_list = []

        # logfile = open('folding.log', 'wt')
        for cand in cands:
            #foldcmd = "prepfold -dm %(dm)f -accelcand %(candnum)d -accelfile %(accelfile)s %(datfile)s -noxwin " % {
            #'dm':cand.DM,  'accelfile':cand.filename+'.cand', 'candnum':cand.candnum, 'datfile':('%s_DM%s.dat' % (rootname, cand.DMstr))} #simple plots
            foldcmd = "prepfold -n %(Nint)d -nsub %(Nsub)d -dm %(dm)f -p %(period)f %(filfile)s -o %(outfile)s -noxwin -nodmsearch" % {
                    'Nint':Nint, 'Nsub':Nsub, 'dm':cand.DM,  'period':cand.p, 'filfile':filename, 'outfile':rootname+'_DM'+cand.DMstr} #full plots
            # print foldcmd
            # dm_list.append(cand.DM)
            prepfold_cmd.append(foldcmd)
            # output = getoutput(foldcmd)
            # logfile.write(output)
        # logfile.close()
        pool = Pool()
        print(prepfold_cmd)
        res = pool.map_async(func=batch_prepfold, iterable=prepfold_cmd, callback=write_fold_log)
        pool.close()
        pool.join()
        res.get()
        os.chdir(cwd)
    except Exception as ex:
        print(ex)
        print 'failed at folding candidates.'
        os.chdir(cwd)
        sys.exit(0)


    ee = time.time()
    print('folding candidates time_cost: ', ee - ss)
