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
import multiprocessing
import mpi4py.MPI as MPI
import traceback


comm = MPI.COMM_WORLD
comm_rank = comm.Get_rank()
comm_size = comm.Get_size()
if not os.access('subbands', os.F_OK):
    os.mkdir('subbands')
else:
    os.system('rm subbands/*')

# print(getoutput("hostname") + " " + str(comm_rank))

# MPI point to point communication example
# data_send = [comm_rank]*5
# comm.send(data_send,dest=(comm_rank+1)%comm_size)
# data_recv =comm.recv(source=(comm_rank-1)%comm_size)
# print("my rank is %d, and Ireceived:" % comm_rank)
# print(data_recv)

rootname = 'Sband'
maxDM = 80 #max DM to search
Nsub = 32 #32 subbands
Nint = 64 #64 sub integration
Tres = 0.5 #ms
zmax = 0

filepath = sys.argv[1]
dirpath = os.path.dirname(filepath)
if len(sys.argv) > 2:
    maskfile = sys.argv[2]
else:
    maskfile = None
 
def batch_dedisperse(name, prep, prepcmd):
    # ccpu = int(multiprocessing.current_process().name.split("-")[1]) % multiprocessing.cpu_count()
    # print(multiprocessing.current_process().name)
    st = time.time()
    logfile = open('dedisperse_%s.log' % name, 'wt')
    buffer = []
    print(str(comm_rank) + prep)
    output = getoutput(prep)
    buffer.append(output)
    print(str(comm_rank) + prepcmd)
    output = getoutput(prepcmd)
    buffer.append(output)   
    ed = time.time() 
    ttime = "dedisperse_batch_time: %f" % (ed - st)
    buffer.append(ttime)
    logfile.write("\n".join(buffer))
    logfile.close()

def batch_fft(name, real_list, accel_list):
    st = time.time()
    buffer = []
    logfile = open('fft_%s.log' % name, 'wt')
    for cmd in real_list:
        print(str(comm_rank) + cmd)
        output = getoutput(cmd)
        buffer.append(output)
    for cmd in accel_list:
        print(str(comm_rank) + cmd)
        output = getoutput(cmd)
        buffer.append(output)
    ed = time.time()
    ttime = "fft_batch_time: %f" % (ed - st)
    buffer.append(ttime)
    logfile.write("\n".join(buffer))
    logfile.close()

def func_wrap_dedisperse(x):
    return batch_dedisperse(*x)

def func_wrap_fft(x):
    return batch_fft(*x)

def combine_fft_log():
    globdedisperse = "dedisperse_*.log"
    dedisperse_files = glob.glob(globdedisperse)
    fp = open("dedisperse_%d.log" % comm_rank, "wt")
    for file in dedisperse_files:
        with open(file, "r") as f:
            fp.write("\n".join(f.readlines()))
    fp.close()
    glob_fft = "fft_[0-9]*.log"
    fft_files = glob.glob(glob_fft)
    fp = open("fft_%d.log" % comm_rank, "wt")
    for file in fft_files:
        with open(file, "r") as f:
            fp.write("\n".join(f.readlines()))
    fp.close()
    print("finish combine didesperse and fft log on Node: %d" % comm_rank)

def combine_fold_log():
    globfold = "folding_*.log"
    fold_files = glob.glob(globfold)
    fp = open("fold.log", "wt")
    for file in fold_files:
        with open(file, 'r') as f:
            fp.write("\n".join(f.readlines()))
    fp.close()
    print("finish combine folding log on Node:%d" % comm_rank)

def batch_prepfold(fold):
    dm = float(fold.split(" ")[6])
    pp = float(fold.split(" ")[8]) * 1000.0
    st = time.time()
    print(str(comm_rank) + fold)
    output = getoutput(fold)
    ed = time.time()
    ttime = "Node %d single_fold_time: %f" % (comm_rank, (ed - st))
    print(ttime)
    return output


def ACCEL_sift(zmax):
    '''
    The following code come from PRESTO's ACCEL_sift.py
    '''

    globaccel = "*ACCEL_%d" % zmax
    globinf = "*DM*[0-9][0-9].inf" # [lqq] no delete for higher perf
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
            #print cand.filepath, cand.candnum, cand.p, cand.DMstr
        #sifting.write_candlist(cands)
    return cands

if __name__=="__main__":

    print("new 0.1.4: mpi version")
    print("Calculate each part itself on each node with nfs")

    ss = time.time()
    print '''

    ====================Read Header======================

    '''

    readheadercmd = 'readfile %s' % filepath
    output = getoutput(readheadercmd)
    if comm_rank == 0:
        print readheadercmd
        print output
    header = {}
    for line in output.split('\n'):
        items = line.split("=")
        if len(items) > 1:
            header[items[0].strip()] = items[1].strip()

    ee = time.time()
    print('Read Header time_cost: ', ee - ss)


    ss = time.time()

    print '''

    ============Generate Dedispersion Plan===============

    '''

    try:
        Nchan = int(header['Number of channels'])
        tsamp = float(header['Sample time (us)']) * 1.e-6
        BandWidth = float(header['Total Bandwidth (MHz)'])
        fcenter = float(header['Central freq (MHz)'])
        Nsamp = int(header['Spectra per file'])

        ddplancmd = 'DDplan.py -d %(maxDM)s -n %(Nchan)d -b %(BandWidth)s -t %(tsamp)f -f %(fcenter)f -s %(Nsub)s -o DDplan_%(rank)d.ps' % {
                'maxDM':maxDM, 'Nchan':Nchan, 'tsamp':tsamp, 'BandWidth':BandWidth, 'fcenter':fcenter, 'Nsub':Nsub, 'rank':comm_rank}
        print(ddplancmd)
        ddplanout = getoutput(ddplancmd)
        planlist = ddplanout.split('\n')
        ddplan = []
        planlist.reverse()
        for plan in planlist:
            if plan == '':
                continue
            elif plan.strip().startswith('Low DM'):
                break
            else:
                ddplan.append(plan)
        ddplan.reverse()
    except:
        print 'failed at generating DDplan.'
        sys.exit(0)


    ee = time.time()
    print('Generate Dedispersion Plan time_cost: ', ee - ss)


    cwd = os.getcwd()

    ss = time.time()
    print '''

    ================Dedisperse Subbands==================

    '''

    try:
        if not os.access('subbands', os.F_OK):
            os.mkdir('subbands')
        os.chdir('subbands')

        subDM_list = []
        prepsubband_sub_cmd = []
        prepsubband_nsub_cmd = []
        realfft_cmd = []
        accelsearch_cmd = []


        if len(ddplan) != 1:
            print("Notice, len(ddplan)=%d", len(ddplan))
            exit(-1)

        for line in ddplan:
            ddpl = line.split()
            lowDM = float(ddpl[0])
            hiDM = float(ddpl[1])
            dDM = float(ddpl[2])
            DownSamp = int(ddpl[3])
            NDMs = int(ddpl[6])
            calls = int(ddpl[7])
            Nout = Nsamp/DownSamp 
            Nout -= (Nout % 500)
            dmlist = np.split(np.arange(lowDM, hiDM, dDM), calls)

            #copy from $PRESTO/python/Dedisp.py
            subdownsamp = DownSamp/2
            datdownsamp = 2
            if DownSamp < 2: subdownsamp = datdownsamp = 1
            
            partlen = (calls + comm_size - 1)/comm_size
            # print("calls: %d partlen: %d" % (len(dmlist), partlen))
            startidx = partlen*comm_rank
            endidx = min(partlen*(comm_rank+1), len(dmlist))
            for dml in dmlist[startidx:endidx]:
                lodm = dml[0]
                subDM = np.mean(dml)
                subDM_list.append("%.2f" % subDM)
                if maskfile:
                    prepsubband = "prepsubband -sub -subdm %.2f -nsub %d -downsamp %d -mask ../%s -o %s %s" % (subDM, Nsub, subdownsamp, maskfile, rootname, filepath)
                else:
                    prepsubband = "prepsubband -sub -subdm %.2f -nsub %d -downsamp %d -o %s %s" % (subDM, Nsub, subdownsamp, rootname, filepath)
                prepsubband_sub_cmd.append(prepsubband)

                subnames = rootname+"_DM%.2f.sub[0-9]*" % subDM
                #prepsubcmd = "prepsubband -nsub %(Nsub)d -lodm %(lowdm)f -dmstep %(dDM)f -numdms %(NDMs)d -numout %(Nout)d -downsamp %(DownSamp)d -o %(root)s ../%(filfile)s" % {
                        #'Nsub':Nsub, 'lowdm':lodm, 'dDM':dDM, 'NDMs':NDMs, 'Nout':Nout, 'DownSamp':datdownsamp, 'root':rootname, 'filfile':filepath}
                prepsubcmd = "prepsubband -nsub %(Nsub)d -lodm %(lowdm)f -dmstep %(dDM)f -numdms %(NDMs)d -numout %(Nout)d -downsamp %(DownSamp)d -o %(root)s %(subfile)s" % {
                        'Nsub':Nsub, 'lowdm':lodm, 'dDM':dDM, 'NDMs':NDMs, 'Nout':Nout, 'DownSamp':datdownsamp, 'root':rootname, 'subfile':subnames}
                prepsubband_nsub_cmd.append(prepsubcmd)

                realfft_cmd.append(["realfft Sband_DM%.2f.dat" % j for j in dml])
                accelsearch_cmd.append(["accelsearch -zmax 0 Sband_DM%.2f.fft" % j for j in dml])
                
            print("Node:{} multiprocessing.cpu_count:{}".format(comm_rank, multiprocessing.cpu_count()))
            pool = multiprocessing.Pool(multiprocessing.cpu_count())
            pool.map(func=func_wrap_dedisperse, iterable=zip(subDM_list, prepsubband_sub_cmd, prepsubband_nsub_cmd))
            pool.close()
            pool.join()
            pool2 = multiprocessing.Pool(multiprocessing.cpu_count())
            pool2.map(func=func_wrap_fft, iterable=zip(subDM_list, realfft_cmd, accelsearch_cmd))
            pool2.close()
            pool2.join()

        combine_fft_log()

        comm.Barrier()
        os.chdir(cwd)
    except Exception as ex:
        print(ex)
        traceback.print_exc()
        print 'failed at prepsubband.'
        os.chdir(cwd)
        sys.exit(0)

    ee = time.time()
    print('Node %d Dedisperse Subbands time_cost: %f' % (comm_rank, ee - ss))
   
    ss = time.time()
    if comm_rank == 0:
        cwd = os.getcwd()
        os.chdir('subbands')
        for i in range(1, comm_size):
            print(getoutput("pigz -p 32 -d Node_fft_%d.tgz" % i))
            print(getoutput("tar xf Node_fft_%d.tar" % i))

        print '''

        ================sifting candidates==================

        '''

        try:
            
            cands = ACCEL_sift(zmax)
            os.chdir(cwd)
        except Exception as ex:
            traceback.print_exc()
            os.chdir(cwd)
            exit(-1)
        
        cwd = os.getcwd()

        fold_cmd = []
        for cand in cands:
            #foldcmd = "prepfold -dm %(dm)f -accelcand %(candnum)d -accelfile %(accelfile)s %(datfile)s -noxwin " % {
            #'dm':cand.DM,  'accelfile':cand.filepath+'.cand', 'candnum':cand.candnum, 'datfile':('%s_DM%s.dat' % (rootname, cand.DMstr))} #simple plots
            foldcmd = "prepfold -n %(Nint)d -nsub %(Nsub)d -dm %(dm)f -p %(period)f %(filfile)s -o %(outfile)s -noxwin -nodmsearch" % {
                    'Nint':Nint, 'Nsub':Nsub, 'dm':cand.DM,  'period':cand.p, 'filfile':filepath, 'outfile':rootname+'_DM'+cand.DMstr} #full plots
            fold_cmd.append(foldcmd)

        print("len(fold_cmd):%d" % len(fold_cmd))
        partlen = (len(cands) + comm_size - 1)/comm_size
        for i in range(1, comm_size):
            print("Node 0 send fold_cmd to Node %d" % i)
            comm.send(fold_cmd[partlen*i:min(partlen*(i+1), len(cands))], dest=i, tag=i)
            print("Node 0 send finished")

        fold_cmd = fold_cmd[0: partlen]
    else:
        print("Node {} waiting for fold_cmd".format(comm_rank))
        fold_cmd = comm.recv(source=0, tag=comm_rank)
        print("Node {} receive fold_cmd".format(comm_rank))

    ee = time.time()
    print("Node %d sifiting time_cost: %f" % (comm_rank, ee - ss))

    ss = time.time()
    cwd = os.getcwd()
    print '''

    ================folding candidates==================

    '''

    try:
        os.chdir('subbands')
        os.system('ln -s %s %s' % (filepath, os.path.basename(filepath)))

        pool = multiprocessing.Pool(multiprocessing.cpu_count())
        res = pool.map(func=batch_prepfold, iterable=fold_cmd)
        pool.close()
        pool.join()

        with open("folding_%d.log" % comm_rank, 'wt') as fp:
            fp.write("\n".join(res))

        print("Node %d finish prepfold process" % comm_rank)
        
        comm.Barrier()
        os.chdir(cwd)
    except Exception as ex:
        traceback.print_exc()
        print 'failed at folding candidates.'
        os.chdir(cwd)
        sys.exit(0)

    if comm_rank == 0:
        ee = time.time()
        os.chdir('subbands')
        for i in range(1, comm_size):
            print(getoutput("pigz -p 32 -d Node_fold_%d.tgz" % i))
            print(getoutput("tar xf Node_fold_%d.tar" % i))
        combine_fold_log()
        print('folding candidates time_cost: ', ee - ss)
        print("Node %d exit" % comm_rank)
        exit(0)

        
    

