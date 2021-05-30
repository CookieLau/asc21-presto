	.section .text
.LNDBG_TX:
# mark_description "Intel(R) C Intel(R) 64 Compiler for applications running on Intel(R) 64, Version 19.1.2.254 Build 20200623";
# mark_description "-DUSEMMAP -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -g -Wall -W -fPIC -O3 -ffast-math -S -fverbose-asm";
	.file "fresnel.c"
	.text
..TXTST0:
.L_2__routine_start_fresnl_0:
# -- Begin  fresnl
	.text
# mark_begin;
       .align    16,0x90
	.globl fresnl
# --- fresnl(double, double *, double *)
fresnl:
# parameter 1(x): %xmm0
# parameter 2(s): %rdi
# parameter 3(c): %rsi
..B1.1:                         # Preds ..B1.0
                                # Execution count [1.00e+00]
	.cfi_startproc
..___tag_value_fresnl.2:
..L3:
                                                          #2.1
..LN0:
	.file   1 "fresnel.c"
	.loc    1  2  is_stmt 1
        pushq     %r13                                          #2.1
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
..LN1:
        pushq     %r14                                          #2.1
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
..LN2:
        pushq     %r15                                          #2.1
	.cfi_def_cfa_offset 32
	.cfi_offset 15, -32
..LN3:
        subq      $32, %rsp                                     #2.1
	.cfi_def_cfa_offset 64
..LN4:
        movq      %rsi, %r15                                    #2.1
..LN5:
	.loc    1  21  prologue_end  is_stmt 1
        pxor      %xmm1, %xmm1                                  #21.19
..LN6:
	.loc    1  2  is_stmt 1
        movq      %rdi, %r14                                    #2.1
..LN7:
        movsd     %xmm0, 16(%rsp)                               #2.1[spill]
..LN8:
	.loc    1  21  is_stmt 1
        comisd    %xmm1, %xmm0                                  #21.19
..LN9:
        jbe       ..B1.3        # Prob 50%                      #21.19
..LN10:
                                # LOE rbx rbp r12 r14 r15 xmm0 xmm1
..B1.2:                         # Preds ..B1.1
                                # Execution count [5.00e-01]
..LN11:
        movl      $1, %r13d                                     #21.19
..LN12:
        jmp       ..B1.4        # Prob 100%                     #21.19
..LN13:
                                # LOE rbx rbp r12 r14 r15 r13d
..B1.3:                         # Preds ..B1.1
                                # Execution count [5.00e-01]
..LN14:
        cmpltsd   %xmm1, %xmm0                                  #21.19
..LN15:
        movd      %xmm0, %r13d                                  #21.19
..LN16:
                                # LOE rbx rbp r12 r14 r15 r13d
..B1.4:                         # Preds ..B1.2 ..B1.3
                                # Execution count [1.00e+00]
..LN17:
	.loc    1  26  is_stmt 1
        movsd     16(%rsp), %xmm1                               #26.9[spill]
..LN18:
        andps     .L_2il0floatpacket.69(%rip), %xmm1            #26.9
..LN19:
        movsd     %xmm1, 16(%rsp)                               #26.9[spill]
..LN20:
	.loc    1  28  is_stmt 1
        mulsd     %xmm1, %xmm1                                  #28.12
..LN21:
	.loc    1  29  is_stmt 1
        movsd     .L_2il0floatpacket.0(%rip), %xmm0             #29.14
..LN22:
        comisd    %xmm1, %xmm0                                  #29.14
..LN23:
        ja        ..B1.8        # Prob 28%                      #29.14
..LN24:
                                # LOE rbx rbp r12 r14 r15 r13d xmm1
..B1.5:                         # Preds ..B1.4
                                # Execution count [7.20e-01]
..LN25:
	.loc    1  62  is_stmt 1
        movsd     16(%rsp), %xmm0                               #62.13[spill]
..LN26:
        comisd    .L_2il0floatpacket.25(%rip), %xmm0            #62.13
..LN27:
        jbe       ..B1.7        # Prob 50%                      #62.13
..LN28:
                                # LOE rbx rbp r12 r14 r15 r13d xmm1
..B1.6:                         # Preds ..B1.5
                                # Execution count [3.60e-01]
..LN29:
	.loc    1  64  is_stmt 1
        pxor      %xmm0, %xmm0                                  #64.14
..LN30:
        cvtsi2sd  %r13d, %xmm0                                  #64.14
..LN31:
        movsd     .L_2il0floatpacket.24(%rip), %xmm1            #64.19
..LN32:
        mulsd     %xmm0, %xmm1                                  #64.19
..LN33:
        movsd     %xmm1, (%r14)                                 #64.10
..LN34:
	.loc    1  65  is_stmt 1
        movsd     %xmm1, (%r15)                                 #65.10
..LN35:
	.loc    1  66  epilogue_begin  is_stmt 1
        addq      $32, %rsp                                     #66.9
	.cfi_def_cfa_offset 32
	.cfi_restore 15
..LN36:
        popq      %r15                                          #66.9
	.cfi_def_cfa_offset 24
	.cfi_restore 14
..LN37:
        popq      %r14                                          #66.9
	.cfi_def_cfa_offset 16
	.cfi_restore 13
..LN38:
        popq      %r13                                          #66.9
	.cfi_def_cfa_offset 8
..LN39:
        ret                                                     #66.9
	.cfi_def_cfa_offset 64
	.cfi_offset 13, -16
	.cfi_offset 14, -24
	.cfi_offset 15, -32
..LN40:
                                # LOE
..B1.7:                         # Preds ..B1.5
                                # Execution count [3.60e-01]
..LN41:
	.loc    1  23  is_stmt 1
        movsd     .L_2il0floatpacket.26(%rip), %xmm0            #23.5
..LN42:
	.loc    1  69  is_stmt 1
        mulsd     %xmm1, %xmm0                                  #69.13
..LN43:
	.loc    1  70  is_stmt 1
        movaps    %xmm0, %xmm2                                  #70.14
..LN44:
        mulsd     %xmm0, %xmm2                                  #70.14
..LN45:
        movsd     .L_2il0floatpacket.70(%rip), %xmm6            #70.14
..LN46:
        divsd     %xmm2, %xmm6                                  #70.14
..LN47:
	.loc    1  94  is_stmt 1
        movsd     .L_2il0floatpacket.57(%rip), %xmm9            #94.13
..LN48:
        mulsd     %xmm6, %xmm9                                  #94.13
..LN49:
	.loc    1  105  is_stmt 1
        movsd     .L_2il0floatpacket.67(%rip), %xmm8            #105.15
..LN50:
	.loc    1  72  is_stmt 1
        movsd     .L_2il0floatpacket.36(%rip), %xmm4            #72.10
..LN51:
	.loc    1  105  is_stmt 1
        addsd     %xmm6, %xmm8                                  #105.15
..LN52:
	.loc    1  73  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #73.13
..LN53:
	.loc    1  94  is_stmt 1
        addsd     .L_2il0floatpacket.56(%rip), %xmm9            #94.15
..LN54:
	.loc    1  106  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #106.13
..LN55:
	.loc    1  73  is_stmt 1
        addsd     .L_2il0floatpacket.35(%rip), %xmm4            #73.15
..LN56:
	.loc    1  95  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #95.13
..LN57:
	.loc    1  106  is_stmt 1
        addsd     .L_2il0floatpacket.66(%rip), %xmm8            #106.15
..LN58:
	.loc    1  74  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #74.13
..LN59:
	.loc    1  95  is_stmt 1
        addsd     .L_2il0floatpacket.55(%rip), %xmm9            #95.15
..LN60:
	.loc    1  107  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #107.13
..LN61:
	.loc    1  74  is_stmt 1
        addsd     .L_2il0floatpacket.34(%rip), %xmm4            #74.15
..LN62:
	.loc    1  96  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #96.13
..LN63:
	.loc    1  107  is_stmt 1
        addsd     .L_2il0floatpacket.65(%rip), %xmm8            #107.15
..LN64:
	.loc    1  75  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #75.13
..LN65:
	.loc    1  96  is_stmt 1
        addsd     .L_2il0floatpacket.54(%rip), %xmm9            #96.15
..LN66:
	.loc    1  108  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #108.13
..LN67:
	.loc    1  75  is_stmt 1
        addsd     .L_2il0floatpacket.33(%rip), %xmm4            #75.15
..LN68:
	.loc    1  97  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #97.13
..LN69:
	.loc    1  108  is_stmt 1
        addsd     .L_2il0floatpacket.64(%rip), %xmm8            #108.15
..LN70:
	.loc    1  76  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #76.13
..LN71:
	.loc    1  97  is_stmt 1
        addsd     .L_2il0floatpacket.53(%rip), %xmm9            #97.15
..LN72:
	.loc    1  109  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #109.13
..LN73:
	.loc    1  76  is_stmt 1
        addsd     .L_2il0floatpacket.32(%rip), %xmm4            #76.15
..LN74:
	.loc    1  98  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #98.13
..LN75:
	.loc    1  109  is_stmt 1
        addsd     .L_2il0floatpacket.63(%rip), %xmm8            #109.15
..LN76:
	.loc    1  77  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #77.13
..LN77:
	.loc    1  98  is_stmt 1
        addsd     .L_2il0floatpacket.52(%rip), %xmm9            #98.15
..LN78:
	.loc    1  110  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #110.13
..LN79:
	.loc    1  77  is_stmt 1
        addsd     .L_2il0floatpacket.31(%rip), %xmm4            #77.15
..LN80:
	.loc    1  99  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #99.13
..LN81:
	.loc    1  110  is_stmt 1
        addsd     .L_2il0floatpacket.62(%rip), %xmm8            #110.15
..LN82:
	.loc    1  78  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #78.13
..LN83:
	.loc    1  99  is_stmt 1
        addsd     .L_2il0floatpacket.51(%rip), %xmm9            #99.15
..LN84:
	.loc    1  111  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #111.13
..LN85:
	.loc    1  78  is_stmt 1
        addsd     .L_2il0floatpacket.30(%rip), %xmm4            #78.15
..LN86:
	.loc    1  100  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #100.13
..LN87:
	.loc    1  111  is_stmt 1
        addsd     .L_2il0floatpacket.61(%rip), %xmm8            #111.15
..LN88:
	.loc    1  79  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #79.13
..LN89:
	.loc    1  100  is_stmt 1
        addsd     .L_2il0floatpacket.50(%rip), %xmm9            #100.15
..LN90:
	.loc    1  112  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #112.13
..LN91:
	.loc    1  79  is_stmt 1
        addsd     .L_2il0floatpacket.29(%rip), %xmm4            #79.15
..LN92:
	.loc    1  101  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #101.13
..LN93:
	.loc    1  112  is_stmt 1
        addsd     .L_2il0floatpacket.60(%rip), %xmm8            #112.15
..LN94:
	.loc    1  80  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #80.13
..LN95:
	.loc    1  101  is_stmt 1
        addsd     .L_2il0floatpacket.49(%rip), %xmm9            #101.15
..LN96:
	.loc    1  113  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #113.13
..LN97:
	.loc    1  80  is_stmt 1
        addsd     .L_2il0floatpacket.28(%rip), %xmm4            #80.15
..LN98:
	.loc    1  102  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #102.13
..LN99:
	.loc    1  113  is_stmt 1
        addsd     .L_2il0floatpacket.59(%rip), %xmm8            #113.15
..LN100:
	.loc    1  81  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #81.13
..LN101:
	.loc    1  102  is_stmt 1
        addsd     .L_2il0floatpacket.48(%rip), %xmm9            #102.15
..LN102:
	.loc    1  114  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #114.13
..LN103:
	.loc    1  81  is_stmt 1
        addsd     .L_2il0floatpacket.27(%rip), %xmm4            #81.15
..LN104:
	.loc    1  103  is_stmt 1
        mulsd     %xmm6, %xmm9                                  #103.13
..LN105:
	.loc    1  114  is_stmt 1
        addsd     .L_2il0floatpacket.58(%rip), %xmm8            #114.15
..LN106:
	.loc    1  116  is_stmt 1
        mulsd     %xmm6, %xmm4                                  #116.13
..LN107:
	.loc    1  115  is_stmt 1
        mulsd     %xmm6, %xmm8                                  #115.13
..LN108:
	.loc    1  83  is_stmt 1
        movsd     .L_2il0floatpacket.46(%rip), %xmm3            #83.15
..LN109:
	.loc    1  103  is_stmt 1
        movsd     .L_2il0floatpacket.47(%rip), %xmm7            #103.15
..LN110:
	.loc    1  83  is_stmt 1
        addsd     %xmm6, %xmm3                                  #83.15
..LN111:
	.loc    1  103  is_stmt 1
        addsd     %xmm7, %xmm9                                  #103.15
..LN112:
	.loc    1  115  is_stmt 1
        addsd     %xmm8, %xmm7                                  #115.15
..LN113:
	.loc    1  84  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #84.13
..LN114:
	.loc    1  117  is_stmt 1
        divsd     %xmm0, %xmm9                                  #117.11
..LN115:
        divsd     %xmm7, %xmm9                                  #117.14
..LN116:
	.loc    1  119  is_stmt 1
        movsd     .L_2il0floatpacket.68(%rip), %xmm0            #119.10
..LN117:
	.loc    1  116  is_stmt 1
        movsd     .L_2il0floatpacket.70(%rip), %xmm5            #116.16
..LN118:
	.loc    1  119  is_stmt 1
        mulsd     %xmm1, %xmm0                                  #119.10
..LN119:
	.loc    1  84  is_stmt 1
        addsd     .L_2il0floatpacket.45(%rip), %xmm3            #84.15
..LN120:
	.loc    1  85  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #85.13
..LN121:
	.loc    1  117  is_stmt 1
        movsd     %xmm9, 8(%rsp)                                #117.14[spill]
..LN122:
	.loc    1  85  is_stmt 1
        addsd     .L_2il0floatpacket.44(%rip), %xmm3            #85.15
..LN123:
	.loc    1  86  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #86.13
..LN124:
        addsd     .L_2il0floatpacket.43(%rip), %xmm3            #86.15
..LN125:
	.loc    1  87  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #87.13
..LN126:
        addsd     .L_2il0floatpacket.42(%rip), %xmm3            #87.15
..LN127:
	.loc    1  88  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #88.13
..LN128:
        addsd     .L_2il0floatpacket.41(%rip), %xmm3            #88.15
..LN129:
	.loc    1  89  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #89.13
..LN130:
        addsd     .L_2il0floatpacket.40(%rip), %xmm3            #89.15
..LN131:
	.loc    1  90  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #90.13
..LN132:
        addsd     .L_2il0floatpacket.39(%rip), %xmm3            #90.15
..LN133:
	.loc    1  91  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #91.13
..LN134:
        addsd     .L_2il0floatpacket.38(%rip), %xmm3            #91.15
..LN135:
	.loc    1  92  is_stmt 1
        mulsd     %xmm6, %xmm3                                  #92.13
..LN136:
        addsd     .L_2il0floatpacket.37(%rip), %xmm3            #92.15
..LN137:
	.loc    1  116  is_stmt 1
        divsd     %xmm3, %xmm4                                  #116.16
..LN138:
        subsd     %xmm4, %xmm5                                  #116.16
..LN139:
        movsd     %xmm5, (%rsp)                                 #116.16[spill]
..LN140:
	.loc    1  119  is_stmt 1
        call      __libm_sse2_sincos@PLT                        #119.10
..LN141:
	.loc    1  122  is_stmt 1
        movsd     (%rsp), %xmm14                                #122.17[spill]
..LN142:
        movaps    %xmm1, %xmm10                                 #122.22
..LN143:
        movsd     8(%rsp), %xmm12                               #122.22[spill]
..LN144:
        movaps    %xmm14, %xmm11                                #122.17
..LN145:
        mulsd     %xmm0, %xmm11                                 #122.17
..LN146:
        mulsd     %xmm12, %xmm10                                #122.22
..LN147:
	.loc    1  123  is_stmt 1
        mulsd     %xmm1, %xmm14                                 #123.17
..LN148:
        mulsd     %xmm12, %xmm0                                 #123.22
..LN149:
	.loc    1  122  is_stmt 1
        subsd     %xmm10, %xmm11                                #122.22
..LN150:
	.loc    1  123  is_stmt 1
        addsd     %xmm0, %xmm14                                 #123.22
..LN151:
	.loc    1  121  is_stmt 1
        movsd     16(%rsp), %xmm13                              #121.13[spill]
..LN152:
	.loc    1  124  is_stmt 1
        pxor      %xmm1, %xmm1                                  #124.13
..LN153:
	.loc    1  121  is_stmt 1
        mulsd     .L_2il0floatpacket.26(%rip), %xmm13           #121.13
..LN154:
	.loc    1  124  is_stmt 1
        cvtsi2sd  %r13d, %xmm1                                  #124.13
..LN155:
	.loc    1  122  is_stmt 1
        divsd     %xmm13, %xmm11                                #122.26
..LN156:
	.loc    1  123  is_stmt 1
        divsd     %xmm13, %xmm14                                #123.26
..LN157:
        movsd     .L_2il0floatpacket.24(%rip), %xmm15           #123.26
..LN158:
	.loc    1  122  is_stmt 1
        addsd     .L_2il0floatpacket.24(%rip), %xmm11           #122.26
..LN159:
	.loc    1  123  is_stmt 1
        subsd     %xmm14, %xmm15                                #123.26
..LN160:
	.loc    1  122  is_stmt 1
        movsd     %xmm11, (%r15)                                #122.6
..LN161:
	.loc    1  123  is_stmt 1
        movsd     %xmm15, (%r14)                                #123.6
..LN162:
	.loc    1  124  is_stmt 1
        movsd     (%r15), %xmm0                                 #124.11
..LN163:
        mulsd     %xmm1, %xmm0                                  #124.13
..LN164:
        movsd     %xmm0, (%r15)                                 #124.6
..LN165:
	.loc    1  125  is_stmt 1
        movsd     (%r14), %xmm2                                 #125.11
..LN166:
        mulsd     %xmm1, %xmm2                                  #125.13
..LN167:
        movsd     %xmm2, (%r14)                                 #125.6
..LN168:
	.loc    1  126  epilogue_begin  is_stmt 1
        addq      $32, %rsp                                     #126.1
	.cfi_def_cfa_offset 32
	.cfi_restore 15
..LN169:
        popq      %r15                                          #126.1
	.cfi_def_cfa_offset 24
	.cfi_restore 14
..LN170:
        popq      %r14                                          #126.1
	.cfi_def_cfa_offset 16
	.cfi_restore 13
..LN171:
        popq      %r13                                          #126.1
	.cfi_def_cfa_offset 8
..LN172:
        ret                                                     #126.1
	.cfi_def_cfa_offset 64
	.cfi_offset 13, -16
	.cfi_offset 14, -24
	.cfi_offset 15, -32
..LN173:
                                # LOE
..B1.8:                         # Preds ..B1.4
                                # Execution count [2.80e-01]
..LN174:
	.loc    1  31  is_stmt 1
        movaps    %xmm1, %xmm4                                  #31.16
..LN175:
	.loc    1  58  is_stmt 1
        pxor      %xmm0, %xmm0                                  #58.14
..LN176:
	.loc    1  31  is_stmt 1
        mulsd     %xmm1, %xmm4                                  #31.16
..LN177:
	.loc    1  58  is_stmt 1
        cvtsi2sd  %r13d, %xmm0                                  #58.14
..LN178:
	.loc    1  32  is_stmt 1
        movsd     .L_2il0floatpacket.4(%rip), %xmm2             #32.14
..LN179:
	.loc    1  39  is_stmt 1
        movsd     .L_2il0floatpacket.12(%rip), %xmm3            #39.19
..LN180:
	.loc    1  33  is_stmt 1
        mulsd     %xmm4, %xmm2                                  #33.17
..LN181:
	.loc    1  39  is_stmt 1
        addsd     %xmm4, %xmm3                                  #39.19
..LN182:
	.loc    1  40  is_stmt 1
        mulsd     %xmm4, %xmm3                                  #40.17
..LN183:
	.loc    1  33  is_stmt 1
        addsd     .L_2il0floatpacket.3(%rip), %xmm2             #33.19
..LN184:
	.loc    1  34  is_stmt 1
        mulsd     %xmm4, %xmm2                                  #34.17
..LN185:
	.loc    1  40  is_stmt 1
        addsd     .L_2il0floatpacket.11(%rip), %xmm3            #40.19
..LN186:
	.loc    1  41  is_stmt 1
        mulsd     %xmm4, %xmm3                                  #41.17
..LN187:
	.loc    1  34  is_stmt 1
        subsd     .L_2il0floatpacket.5(%rip), %xmm2             #34.19
..LN188:
	.loc    1  35  is_stmt 1
        mulsd     %xmm4, %xmm2                                  #35.17
..LN189:
	.loc    1  41  is_stmt 1
        addsd     .L_2il0floatpacket.10(%rip), %xmm3            #41.19
..LN190:
	.loc    1  42  is_stmt 1
        mulsd     %xmm4, %xmm3                                  #42.17
..LN191:
	.loc    1  35  is_stmt 1
        addsd     .L_2il0floatpacket.2(%rip), %xmm2             #35.19
..LN192:
	.loc    1  36  is_stmt 1
        mulsd     %xmm4, %xmm2                                  #36.17
..LN193:
	.loc    1  42  is_stmt 1
        addsd     .L_2il0floatpacket.9(%rip), %xmm3             #42.19
..LN194:
	.loc    1  43  is_stmt 1
        mulsd     %xmm4, %xmm3                                  #43.17
..LN195:
	.loc    1  36  is_stmt 1
        subsd     .L_2il0floatpacket.6(%rip), %xmm2             #36.19
..LN196:
	.loc    1  58  is_stmt 1
        movsd     16(%rsp), %xmm7                               #58.19[spill]
..LN197:
        mulsd     %xmm0, %xmm7                                  #58.19
..LN198:
	.loc    1  43  is_stmt 1
        addsd     .L_2il0floatpacket.8(%rip), %xmm3             #43.19
..LN199:
	.loc    1  37  is_stmt 1
        mulsd     %xmm4, %xmm2                                  #37.17
..LN200:
	.loc    1  58  is_stmt 1
        mulsd     %xmm7, %xmm1                                  #58.21
..LN201:
	.loc    1  44  is_stmt 1
        mulsd     %xmm4, %xmm3                                  #44.17
..LN202:
	.loc    1  37  is_stmt 1
        addsd     .L_2il0floatpacket.1(%rip), %xmm2             #37.19
..LN203:
	.loc    1  58  is_stmt 1
        mulsd     %xmm2, %xmm1                                  #58.24
..LN204:
	.loc    1  44  is_stmt 1
        addsd     .L_2il0floatpacket.7(%rip), %xmm3             #44.19
..LN205:
	.loc    1  58  is_stmt 1
        divsd     %xmm3, %xmm1                                  #58.27
..LN206:
	.loc    1  51  is_stmt 1
        movsd     .L_2il0floatpacket.23(%rip), %xmm6            #51.14
..LN207:
	.loc    1  52  is_stmt 1
        mulsd     %xmm4, %xmm6                                  #52.17
..LN208:
	.loc    1  58  is_stmt 1
        movsd     %xmm1, (%r14)                                 #58.10
..LN209:
	.loc    1  45  is_stmt 1
        movsd     .L_2il0floatpacket.15(%rip), %xmm1            #45.14
..LN210:
	.loc    1  46  is_stmt 1
        mulsd     %xmm4, %xmm1                                  #46.17
..LN211:
	.loc    1  52  is_stmt 1
        addsd     .L_2il0floatpacket.22(%rip), %xmm6            #52.19
..LN212:
	.loc    1  53  is_stmt 1
        mulsd     %xmm4, %xmm6                                  #53.17
..LN213:
	.loc    1  46  is_stmt 1
        addsd     .L_2il0floatpacket.14(%rip), %xmm1            #46.19
..LN214:
	.loc    1  47  is_stmt 1
        mulsd     %xmm4, %xmm1                                  #47.17
..LN215:
	.loc    1  53  is_stmt 1
        addsd     .L_2il0floatpacket.21(%rip), %xmm6            #53.19
..LN216:
	.loc    1  54  is_stmt 1
        mulsd     %xmm4, %xmm6                                  #54.17
..LN217:
	.loc    1  47  is_stmt 1
        subsd     .L_2il0floatpacket.16(%rip), %xmm1            #47.19
..LN218:
	.loc    1  48  is_stmt 1
        mulsd     %xmm4, %xmm1                                  #48.17
..LN219:
	.loc    1  54  is_stmt 1
        addsd     .L_2il0floatpacket.20(%rip), %xmm6            #54.19
..LN220:
	.loc    1  55  is_stmt 1
        mulsd     %xmm4, %xmm6                                  #55.17
..LN221:
	.loc    1  48  is_stmt 1
        addsd     .L_2il0floatpacket.13(%rip), %xmm1            #48.19
..LN222:
	.loc    1  49  is_stmt 1
        mulsd     %xmm4, %xmm1                                  #49.17
..LN223:
	.loc    1  55  is_stmt 1
        addsd     .L_2il0floatpacket.19(%rip), %xmm6            #55.19
..LN224:
	.loc    1  56  is_stmt 1
        mulsd     %xmm4, %xmm6                                  #56.17
..LN225:
	.loc    1  49  is_stmt 1
        subsd     .L_2il0floatpacket.17(%rip), %xmm1            #49.19
..LN226:
	.loc    1  50  is_stmt 1
        mulsd     %xmm4, %xmm1                                  #50.17
..LN227:
	.loc    1  56  is_stmt 1
        addsd     .L_2il0floatpacket.18(%rip), %xmm6            #56.19
..LN228:
	.loc    1  59  is_stmt 1
        movsd     .L_2il0floatpacket.70(%rip), %xmm5            #59.10
..LN229:
	.loc    1  57  is_stmt 1
        mulsd     %xmm4, %xmm6                                  #57.17
..LN230:
	.loc    1  50  is_stmt 1
        addsd     %xmm5, %xmm1                                  #50.19
..LN231:
	.loc    1  59  is_stmt 1
        mulsd     %xmm1, %xmm7                                  #59.21
..LN232:
	.loc    1  57  is_stmt 1
        addsd     %xmm6, %xmm5                                  #57.19
..LN233:
	.loc    1  59  is_stmt 1
        divsd     %xmm5, %xmm7                                  #59.24
..LN234:
        movsd     %xmm7, (%r15)                                 #59.10
..LN235:
	.loc    1  60  epilogue_begin  is_stmt 1
        addq      $32, %rsp                                     #60.9
	.cfi_def_cfa_offset 32
	.cfi_restore 15
..LN236:
        popq      %r15                                          #60.9
	.cfi_def_cfa_offset 24
	.cfi_restore 14
..LN237:
        popq      %r14                                          #60.9
	.cfi_def_cfa_offset 16
	.cfi_restore 13
..LN238:
        popq      %r13                                          #60.9
	.cfi_def_cfa_offset 8
..LN239:
        ret                                                     #60.9
        .align    16,0x90
..LN240:
                                # LOE
..LN241:
	.cfi_endproc
# mark_end;
	.type	fresnl,@function
	.size	fresnl,.-fresnl
..LNfresnl.242:
.LNfresnl:
	.data
# -- End  fresnl
	.section .rodata, "a"
	.align 16
	.align 16
.L_2il0floatpacket.69:
	.long	0xffffffff,0x7fffffff,0x00000000,0x00000000
	.type	.L_2il0floatpacket.69,@object
	.size	.L_2il0floatpacket.69,16
	.align 8
.L_2il0floatpacket.0:
	.long	0x00000000,0x40048000
	.type	.L_2il0floatpacket.0,@object
	.size	.L_2il0floatpacket.0,8
	.align 8
.L_2il0floatpacket.1:
	.long	0xe6e52457,0x425282cf
	.type	.L_2il0floatpacket.1,@object
	.size	.L_2il0floatpacket.1,8
	.align 8
.L_2il0floatpacket.2:
	.long	0x60b77afe,0x41e2fda8
	.type	.L_2il0floatpacket.2,@object
	.size	.L_2il0floatpacket.2,8
	.align 8
.L_2il0floatpacket.3:
	.long	0x172c05b6,0x4125a1d0
	.type	.L_2il0floatpacket.3,@object
	.size	.L_2il0floatpacket.3,8
	.align 8
.L_2il0floatpacket.4:
	.long	0x6d65b5c3,0xc0a75fa3
	.type	.L_2il0floatpacket.4,@object
	.size	.L_2il0floatpacket.4,8
	.align 8
.L_2il0floatpacket.5:
	.long	0x24f6f5ed,0x418e0746
	.type	.L_2il0floatpacket.5,@object
	.size	.L_2il0floatpacket.5,8
	.align 8
.L_2il0floatpacket.6:
	.long	0x347bf087,0x4224a0ba
	.type	.L_2il0floatpacket.6,@object
	.size	.L_2il0floatpacket.6,8
	.align 8
.L_2il0floatpacket.7:
	.long	0x73de42b5,0x4261ad3b
	.type	.L_2il0floatpacket.7,@object
	.size	.L_2il0floatpacket.7,8
	.align 8
.L_2il0floatpacket.8:
	.long	0xe6b222e9,0x4214e664
	.type	.L_2il0floatpacket.8,@object
	.size	.L_2il0floatpacket.8,8
	.align 8
.L_2il0floatpacket.9:
	.long	0xb5e5ea9e,0x41b8fe51
	.type	.L_2il0floatpacket.9,@object
	.size	.L_2il0floatpacket.9,8
	.align 8
.L_2il0floatpacket.10:
	.long	0xb8d017b4,0x4153bc2f
	.type	.L_2il0floatpacket.10,@object
	.size	.L_2il0floatpacket.10,8
	.align 8
.L_2il0floatpacket.11:
	.long	0xfe9cdaa9,0x40e64218
	.type	.L_2il0floatpacket.11,@object
	.size	.L_2il0floatpacket.11,8
	.align 8
.L_2il0floatpacket.12:
	.long	0x32871072,0x40719605
	.type	.L_2il0floatpacket.12,@object
	.size	.L_2il0floatpacket.12,8
	.align 8
.L_2il0floatpacket.13:
	.long	0x1059cc13,0x3f93566a
	.type	.L_2il0floatpacket.13,@object
	.size	.L_2il0floatpacket.13,8
	.align 8
.L_2il0floatpacket.14:
	.long	0x62100f74,0x3ee3ee92
	.type	.L_2il0floatpacket.14,@object
	.size	.L_2il0floatpacket.14,8
	.align 8
.L_2il0floatpacket.15:
	.long	0x2cfb62d3,0xbe6ac80c
	.type	.L_2il0floatpacket.15,@object
	.size	.L_2il0floatpacket.15,8
	.align 8
.L_2il0floatpacket.16:
	.long	0x0ed68786,0x3f452442
	.type	.L_2il0floatpacket.16,@object
	.size	.L_2il0floatpacket.16,8
	.align 8
.L_2il0floatpacket.17:
	.long	0x378a9690,0x3fca4eac
	.type	.L_2il0floatpacket.17,@object
	.size	.L_2il0floatpacket.17,8
	.align 8
.L_2il0floatpacket.18:
	.long	0x6030fe74,0x3fa51a07
	.type	.L_2il0floatpacket.18,@object
	.size	.L_2il0floatpacket.18,8
	.align 8
.L_2il0floatpacket.19:
	.long	0x3fdbd99d,0x3f4c718f
	.type	.L_2il0floatpacket.19,@object
	.size	.L_2il0floatpacket.19,8
	.align 8
.L_2il0floatpacket.20:
	.long	0xfa2a1d32,0x3ee9a3ee
	.type	.L_2il0floatpacket.20,@object
	.size	.L_2il0floatpacket.20,8
	.align 8
.L_2il0floatpacket.21:
	.long	0x02a45191,0x3e80c708
	.type	.L_2il0floatpacket.21,@object
	.size	.L_2il0floatpacket.21,8
	.align 8
.L_2il0floatpacket.22:
	.long	0xdb0375b9,0x3e0f7449
	.type	.L_2il0floatpacket.22,@object
	.size	.L_2il0floatpacket.22,8
	.align 8
.L_2il0floatpacket.23:
	.long	0x6a7fc6b3,0x3d919768
	.type	.L_2il0floatpacket.23,@object
	.size	.L_2il0floatpacket.23,8
	.align 8
.L_2il0floatpacket.24:
	.long	0x00000000,0x3fe00000
	.type	.L_2il0floatpacket.24,@object
	.size	.L_2il0floatpacket.24,8
	.align 8
.L_2il0floatpacket.25:
	.long	0x00000000,0x40e20dc0
	.type	.L_2il0floatpacket.25,@object
	.size	.L_2il0floatpacket.25,8
	.align 8
.L_2il0floatpacket.26:
	.long	0x54442d18,0x400921fb
	.type	.L_2il0floatpacket.26,@object
	.size	.L_2il0floatpacket.26,8
	.align 8
.L_2il0floatpacket.27:
	.long	0x0e0b05f6,0x3be636ef
	.type	.L_2il0floatpacket.27,@object
	.size	.L_2il0floatpacket.27,8
	.align 8
.L_2il0floatpacket.28:
	.long	0xaf8fa9e4,0x3ca35a2d
	.type	.L_2il0floatpacket.28,@object
	.size	.L_2il0floatpacket.28,8
	.align 8
.L_2il0floatpacket.29:
	.long	0x1459fdf7,0x3d483557
	.type	.L_2il0floatpacket.29,@object
	.size	.L_2il0floatpacket.29,8
	.align 8
.L_2il0floatpacket.30:
	.long	0x4998a7bb,0x3ddc1f0a
	.type	.L_2il0floatpacket.30,@object
	.size	.L_2il0floatpacket.30,8
	.align 8
.L_2il0floatpacket.31:
	.long	0x484e87a1,0x3e6067b5
	.type	.L_2il0floatpacket.31,@object
	.size	.L_2il0floatpacket.31,8
	.align 8
.L_2il0floatpacket.32:
	.long	0xc5357795,0x3ed37203
	.type	.L_2il0floatpacket.32,@object
	.size	.L_2il0floatpacket.32,8
	.align 8
.L_2il0floatpacket.33:
	.long	0xc4950efc,0x3f369c70
	.type	.L_2il0floatpacket.33,@object
	.size	.L_2il0floatpacket.33,8
	.align 8
.L_2il0floatpacket.34:
	.long	0x7b157dad,0x3f8798e5
	.type	.L_2il0floatpacket.34,@object
	.size	.L_2il0floatpacket.34,8
	.align 8
.L_2il0floatpacket.35:
	.long	0xd2b90e5e,0x3fc25b30
	.type	.L_2il0floatpacket.35,@object
	.size	.L_2il0floatpacket.35,8
	.align 8
.L_2il0floatpacket.36:
	.long	0xd1b02391,0x3fdafa91
	.type	.L_2il0floatpacket.36,@object
	.size	.L_2il0floatpacket.36,8
	.align 8
.L_2il0floatpacket.37:
	.long	0x12b96141,0x3bcd9e94
	.type	.L_2il0floatpacket.37,@object
	.size	.L_2il0floatpacket.37,8
	.align 8
.L_2il0floatpacket.38:
	.long	0x2352f48d,0x3c8a0e5d
	.type	.L_2il0floatpacket.38,@object
	.size	.L_2il0floatpacket.38,8
	.align 8
.L_2il0floatpacket.39:
	.long	0x6b9f0790,0x3d30926c
	.type	.L_2il0floatpacket.39,@object
	.size	.L_2il0floatpacket.39,8
	.align 8
.L_2il0floatpacket.40:
	.long	0x33d3a061,0x3dc3cc85
	.type	.L_2il0floatpacket.40,@object
	.size	.L_2il0floatpacket.40,8
	.align 8
.L_2il0floatpacket.41:
	.long	0x95525916,0x3e4833b4
	.type	.L_2il0floatpacket.41,@object
	.size	.L_2il0floatpacket.41,8
	.align 8
.L_2il0floatpacket.42:
	.long	0x923264f5,0x3ebef9b1
	.type	.L_2il0floatpacket.42,@object
	.size	.L_2il0floatpacket.42,8
	.align 8
.L_2il0floatpacket.43:
	.long	0x6017bd60,0x3f24704a
	.type	.L_2il0floatpacket.43,@object
	.size	.L_2il0floatpacket.43,8
	.align 8
.L_2il0floatpacket.44:
	.long	0xa6ed56f3,0x3f7a615e
	.type	.L_2il0floatpacket.44,@object
	.size	.L_2il0floatpacket.44,8
	.align 8
.L_2il0floatpacket.45:
	.long	0xc1d46d7d,0x3fbdec6e
	.type	.L_2il0floatpacket.45,@object
	.size	.L_2il0floatpacket.45,8
	.align 8
.L_2il0floatpacket.46:
	.long	0xeb217a65,0x3fe80cfe
	.type	.L_2il0floatpacket.46,@object
	.size	.L_2il0floatpacket.46,8
	.align 8
.L_2il0floatpacket.47:
	.long	0x624fbe2b,0x3b6c409d
	.type	.L_2il0floatpacket.47,@object
	.size	.L_2il0floatpacket.47,8
	.align 8
.L_2il0floatpacket.48:
	.long	0xf17358a6,0x3c2edb24
	.type	.L_2il0floatpacket.48,@object
	.size	.L_2il0floatpacket.48,8
	.align 8
.L_2il0floatpacket.49:
	.long	0x3df8a964,0x3cd8c7a0
	.type	.L_2il0floatpacket.49,@object
	.size	.L_2il0floatpacket.49,8
	.align 8
.L_2il0floatpacket.50:
	.long	0x876689cb,0x3d730bf5
	.type	.L_2il0floatpacket.50,@object
	.size	.L_2il0floatpacket.50,8
	.align 8
.L_2il0floatpacket.51:
	.long	0xf200eb09,0x3dfe9a94
	.type	.L_2il0floatpacket.51,@object
	.size	.L_2il0floatpacket.51,8
	.align 8
.L_2il0floatpacket.52:
	.long	0x4dea6091,0x3e7a621c
	.type	.L_2il0floatpacket.52,@object
	.size	.L_2il0floatpacket.52,8
	.align 8
.L_2il0floatpacket.53:
	.long	0xf9faabf3,0x3ee82577
	.type	.L_2il0floatpacket.53,@object
	.size	.L_2il0floatpacket.53,8
	.align 8
.L_2il0floatpacket.54:
	.long	0x48d1b33b,0x3f466a79
	.type	.L_2il0floatpacket.54,@object
	.size	.L_2il0floatpacket.54,8
	.align 8
.L_2il0floatpacket.55:
	.long	0x54ba3214,0x3f933718
	.type	.L_2il0floatpacket.55,@object
	.size	.L_2il0floatpacket.55,8
	.align 8
.L_2il0floatpacket.56:
	.long	0x67f87481,0x3fc93aaa
	.type	.L_2il0floatpacket.56,@object
	.size	.L_2il0floatpacket.56,8
	.align 8
.L_2il0floatpacket.57:
	.long	0xb420caca,0x3fe02463
	.type	.L_2il0floatpacket.57,@object
	.size	.L_2il0floatpacket.57,8
	.align 8
.L_2il0floatpacket.58:
	.long	0x84ff8364,0x3c2ef5a1
	.type	.L_2il0floatpacket.58,@object
	.size	.L_2il0floatpacket.58,8
	.align 8
.L_2il0floatpacket.59:
	.long	0x37c81936,0x3cd900dc
	.type	.L_2il0floatpacket.59,@object
	.size	.L_2il0floatpacket.59,8
	.align 8
.L_2il0floatpacket.60:
	.long	0x9c3def2b,0x3d736643
	.type	.L_2il0floatpacket.60,@object
	.size	.L_2il0floatpacket.60,8
	.align 8
.L_2il0floatpacket.61:
	.long	0x8e3cf1c6,0x3dffa861
	.type	.L_2il0floatpacket.61,@object
	.size	.L_2il0floatpacket.61,8
	.align 8
.L_2il0floatpacket.62:
	.long	0xab1c7428,0x3e7c0071
	.type	.L_2il0floatpacket.62,@object
	.size	.L_2il0floatpacket.62,8
	.align 8
.L_2il0floatpacket.63:
	.long	0x2c0a067b,0x3eeabf86
	.type	.L_2il0floatpacket.63,@object
	.size	.L_2il0floatpacket.63,8
	.align 8
.L_2il0floatpacket.64:
	.long	0x0fa0ae28,0x3f4ab206
	.type	.L_2il0floatpacket.64,@object
	.size	.L_2il0floatpacket.64,8
	.align 8
.L_2il0floatpacket.65:
	.long	0xe637aa09,0x3f99f811
	.type	.L_2il0floatpacket.65,@object
	.size	.L_2il0floatpacket.65,8
	.align 8
.L_2il0floatpacket.66:
	.long	0xefa1c34f,0x3fd59dad
	.type	.L_2il0floatpacket.66,@object
	.size	.L_2il0floatpacket.66,8
	.align 8
.L_2il0floatpacket.67:
	.long	0x23bc55c1,0x3ff7996d
	.type	.L_2il0floatpacket.67,@object
	.size	.L_2il0floatpacket.67,8
	.align 8
.L_2il0floatpacket.68:
	.long	0x54442d18,0x3ff921fb
	.type	.L_2il0floatpacket.68,@object
	.size	.L_2il0floatpacket.68,8
	.align 8
.L_2il0floatpacket.70:
	.long	0x00000000,0x3ff00000
	.type	.L_2il0floatpacket.70,@object
	.size	.L_2il0floatpacket.70,8
	.data
	.section .note.GNU-stack, ""
// -- Begin DWARF2 SEGMENT .debug_info
	.section .debug_info
.debug_info_seg:
	.align 1
	.4byte 0x00000143
	.2byte 0x0004
	.4byte .debug_abbrev_seg
	.byte 0x08
//	DW_TAG_compile_unit:
	.byte 0x01
//	DW_AT_comp_dir:
	.4byte .debug_str
//	DW_AT_name:
	.4byte .debug_str+0x2f
//	DW_AT_producer:
	.4byte .debug_str+0x39
	.4byte .debug_str+0xa5
//	DW_AT_language:
	.byte 0x01
//	DW_AT_use_UTF8:
	.byte 0x01
//	DW_AT_low_pc:
	.8byte ..L3
//	DW_AT_high_pc:
	.8byte ..LNfresnl.242-..L3
//	DW_AT_stmt_list:
	.4byte .debug_line_seg
//	DW_TAG_subprogram:
	.byte 0x02
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_prototyped:
	.byte 0x01
//	DW_AT_name:
	.4byte .debug_str+0x10d
	.4byte .debug_str+0x10d
//	DW_AT_low_pc:
	.8byte ..L3
//	DW_AT_high_pc:
	.8byte ..LNfresnl.242-..L3
//	DW_AT_external:
	.byte 0x01
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x00000133
//	DW_AT_name:
	.2byte 0x0078
//	DW_AT_location:
	.2byte 0x6101
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x0000013a
//	DW_AT_name:
	.2byte 0x0073
//	DW_AT_location:
	.2byte 0x5501
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x0000013a
//	DW_AT_name:
	.2byte 0x0063
//	DW_AT_location:
	.2byte 0x5401
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x03
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.4byte 0x00617878
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x04
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x0066
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x05
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x0067
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x06
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6363
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x05
//	DW_AT_decl_line:
	.byte 0x07
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x7373
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_AT_location:
	.2byte 0x6101
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x08
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x0074
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x09
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x0075
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x0a
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x3278
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x0b
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6e73
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x0c
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6473
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x0d
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6e63
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x0e
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6463
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x0f
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6e66
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x10
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6466
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x11
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6e67
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x12
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x6467
	.byte 0x00
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x13
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.4byte 0x0069706d
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x06
//	DW_AT_decl_line:
	.byte 0x14
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.4byte .debug_str+0x11b
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_variable:
	.byte 0x07
//	DW_AT_decl_line:
	.byte 0x15
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.4byte .debug_str+0x121
//	DW_AT_type:
	.4byte 0x0000013f
//	DW_AT_location:
	.2byte 0x5d01
	.byte 0x00
//	DW_TAG_base_type:
	.byte 0x08
//	DW_AT_byte_size:
	.byte 0x08
//	DW_AT_encoding:
	.byte 0x04
//	DW_AT_name:
	.4byte .debug_str+0x114
//	DW_TAG_pointer_type:
	.byte 0x09
//	DW_AT_type:
	.4byte 0x00000133
//	DW_TAG_base_type:
	.byte 0x0a
//	DW_AT_byte_size:
	.byte 0x04
//	DW_AT_encoding:
	.byte 0x05
//	DW_AT_name:
	.4byte 0x00746e69
	.byte 0x00
// -- Begin DWARF2 SEGMENT .debug_line
	.section .debug_line
.debug_line_seg:
	.align 1
// -- Begin DWARF2 SEGMENT .debug_abbrev
	.section .debug_abbrev
.debug_abbrev_seg:
	.align 1
	.byte 0x01
	.byte 0x11
	.byte 0x01
	.byte 0x1b
	.byte 0x0e
	.byte 0x03
	.byte 0x0e
	.byte 0x25
	.byte 0x0e
	.2byte 0x7681
	.byte 0x0e
	.byte 0x13
	.byte 0x0b
	.byte 0x53
	.byte 0x0c
	.byte 0x11
	.byte 0x01
	.byte 0x12
	.byte 0x07
	.byte 0x10
	.byte 0x17
	.2byte 0x0000
	.byte 0x02
	.byte 0x2e
	.byte 0x01
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x27
	.byte 0x0c
	.byte 0x03
	.byte 0x0e
	.2byte 0x4087
	.byte 0x0e
	.byte 0x11
	.byte 0x01
	.byte 0x12
	.byte 0x07
	.byte 0x3f
	.byte 0x0c
	.2byte 0x0000
	.byte 0x03
	.byte 0x05
	.byte 0x00
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x49
	.byte 0x13
	.byte 0x03
	.byte 0x08
	.byte 0x02
	.byte 0x18
	.2byte 0x0000
	.byte 0x04
	.byte 0x34
	.byte 0x00
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x03
	.byte 0x08
	.byte 0x49
	.byte 0x13
	.2byte 0x0000
	.byte 0x05
	.byte 0x34
	.byte 0x00
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x03
	.byte 0x08
	.byte 0x49
	.byte 0x13
	.byte 0x02
	.byte 0x18
	.2byte 0x0000
	.byte 0x06
	.byte 0x34
	.byte 0x00
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x03
	.byte 0x0e
	.byte 0x49
	.byte 0x13
	.2byte 0x0000
	.byte 0x07
	.byte 0x34
	.byte 0x00
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x03
	.byte 0x0e
	.byte 0x49
	.byte 0x13
	.byte 0x02
	.byte 0x18
	.2byte 0x0000
	.byte 0x08
	.byte 0x24
	.byte 0x00
	.byte 0x0b
	.byte 0x0b
	.byte 0x3e
	.byte 0x0b
	.byte 0x03
	.byte 0x0e
	.2byte 0x0000
	.byte 0x09
	.byte 0x0f
	.byte 0x00
	.byte 0x49
	.byte 0x13
	.2byte 0x0000
	.byte 0x0a
	.byte 0x24
	.byte 0x00
	.byte 0x0b
	.byte 0x0b
	.byte 0x3e
	.byte 0x0b
	.byte 0x03
	.byte 0x08
	.2byte 0x0000
	.byte 0x00
// -- Begin DWARF2 SEGMENT .debug_str
	.section .debug_str,"MS",@progbits,1
.debug_str_seg:
	.align 1
	.8byte 0x716c2f656d6f682f
	.8byte 0x6f74736572702f71
	.8byte 0x6c615f687469775f
	.8byte 0x72702f62696c5f6c
	.8byte 0x302e332d6f747365
	.4byte 0x732f312e
	.2byte 0x6372
	.byte 0x00
	.8byte 0x2e6c656e73657266
	.2byte 0x0063
	.8byte 0x2952286c65746e49
	.8byte 0x6c65746e49204320
	.8byte 0x4320343620295228
	.8byte 0x2072656c69706d6f
	.8byte 0x6c70706120726f66
	.8byte 0x736e6f6974616369
	.8byte 0x676e696e6e757220
	.8byte 0x65746e49206e6f20
	.8byte 0x2c3436202952286c
	.8byte 0x6e6f697372655620
	.8byte 0x2e322e312e393120
	.8byte 0x6c69754220343532
	.8byte 0x3630303230322064
	.4byte 0x000a3332
	.8byte 0x414d4d455355442d
	.8byte 0x52414c5f442d2050
	.8byte 0x535f454c49464547
	.8byte 0x442d20454352554f
	.8byte 0x464f5f454c49465f
	.8byte 0x5449425f54455346
	.8byte 0x20672d2034363d53
	.8byte 0x572d206c6c61572d
	.8byte 0x2d20434950662d20
	.8byte 0x736166662d20334f
	.8byte 0x2d206874616d2d74
	.8byte 0x62726576662d2053
	.8byte 0x006d73612d65736f
	.4byte 0x73657266
	.2byte 0x6c6e
	.byte 0x00
	.4byte 0x62756f64
	.2byte 0x656c
	.byte 0x00
	.4byte 0x6f69706d
	.2byte 0x0032
	.4byte 0x6e676973
	.byte 0x00
	.section .text
.LNDBG_TXe:
# End
