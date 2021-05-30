# PRESTO

This is a repo of optimization based on [presto](http://www.cv.nrao.edu/~sransom/presto/) v3.0.1, 
credit to scottransom's src code at [https://github.com/scottransom/presto](https://github.com/scottransom/presto).    

Quote from https://github.com/scottransom/presto    
> PRESTO is a large suite of pulsar search and analysis software
developed primarily by Scott Ransom mostly from scratch, and released
under the GPL (v2).  It was primarily designed to efficiently search
for binary millisecond pulsars from long observations of globular
clusters (although it has since been used in several surveys with
short integrations and to process a lot of X-ray data as well).  It
is written primarily in ANSI C, with many of the recent routines in
Python.  According to Steve Eikenberry, PRESTO stands for: PulsaR
Exploration and Search TOolkit!   

## Optimization
With the help of Intel VTune Amplifier, I detected the bottleneck of PRESTO with four different sizes datasets, and came to the conclusion that the fresnl part in FFT period as well as the clip_times in data preparation and folding are the most critical part.   

To break down the bottleneck of fresnl, I re-implement the fresnl core part with Intel AVX intrinsic in its outer function gen_z_response with a pipeline-like stage, the effect is predominant, the time costs of fresnl part decreases into its half.To use the optimized fresnl code, replace the responses.o and fresnl.o with responses_avx512.o in src/Makefile PRESTOOBJS and recompile the code.     

By looking into the src code of clip_times function, we can see that the memory used in clip time is redundant, it malloced many arrays to store the good points, and many of them are only used once, therefore, we can reuse the memories to reduce the copy operation. Learned from quicksort, I use the double pointers from the begin and the end to swap the good points from the end and bad points from the begin to make all the good points rearranged in the front. The optimization can largely reduce the memory cost as well as the time cost in clip_time function.To use the optimized clip_times, replace the clipping.o with clipping_new.o in src/Makefile PRESTOOBJS and recompile the code.   

In the pipeline folder, there are several pipelines:  
* original_pipeline.py: the original pipelines given by the committee.   
* multi_each_pipeline.py: use multiprocessing to parallel the calculation on single node in each stage separately.
* multipipeline.py: based on multi_each_pipeline.py, combine the prepsubband and FFT part to avoid the unnecessary waiting in not load-balanced situation.
* mpipipelibe_each_stage.py: use mpi and multiprocessing to parallel the calculation on several node in each stage separately.
* mpipipeline.py: based on mpipipeline.py, combine the prepsubband and FFT part as multipipeline.py.
* taskset_pipeline.py: use taskset in linux to assign the task to specific cpu core to avoid process switching cost.

## Final result
The result of speedup with different optimization is shown as below:
![](https://cdn.jsdelivr.net/gh/CookieLau/imghost/img/speedup.png)  
On single-node cluster, the optimization can achieve 31.74x on the smallest datasets.   
On two-node cluster, the optimization can achieve 21.36x on the largest datasets.   

## Contact
Email: cookielau@foxmail.com   
Plz feel free to contact me.  