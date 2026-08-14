; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:33  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:45  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:55  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:67  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:77  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:89  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:13:99  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:23  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:33  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:46  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:57  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:69  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:80  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:91  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:14:102  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:24  in main\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:35  in main\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.52 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:46  in main\0A\00", align 1
@.faila.53 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.54 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.55 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:57  in main\0A\00", align 1
@.faila.56 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.57 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.58 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:69  in main\0A\00", align 1
@.faila.59 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.60 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.61 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:80  in main\0A\00", align 1
@.faila.62 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.63 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.64 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:91  in main\0A\00", align 1
@.faila.65 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.66 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.67 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:15:102  in main\0A\00", align 1
@.faila.68 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.69 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.70 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:24  in main\0A\00", align 1
@.faila.71 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.72 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.73 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:35  in main\0A\00", align 1
@.faila.74 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.75 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.76 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:46  in main\0A\00", align 1
@.faila.77 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.78 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.79 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:57  in main\0A\00", align 1
@.faila.80 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.81 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.82 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:69  in main\0A\00", align 1
@.faila.83 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.84 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.85 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:80  in main\0A\00", align 1
@.faila.86 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.87 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.88 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:91  in main\0A\00", align 1
@.faila.89 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.90 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.91 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:16:102  in main\0A\00", align 1
@.faila.92 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.93 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.94 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:17:24  in main\0A\00", align 1
@.faila.95 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.96 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.97 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:17:35  in main\0A\00", align 1
@.faila.98 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.99 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.100 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:22  in main\0A\00", align 1
@.faila.101 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.102 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.103 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:31  in main\0A\00", align 1
@.faila.104 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.105 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.106 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:42  in main\0A\00", align 1
@.faila.107 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.108 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.109 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:51  in main\0A\00", align 1
@.faila.110 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.111 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.112 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:62  in main\0A\00", align 1
@.faila.113 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.114 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.115 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:71  in main\0A\00", align 1
@.faila.116 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.117 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.118 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:82  in main\0A\00", align 1
@.faila.119 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.120 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.121 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:22:91  in main\0A\00", align 1
@.faila.122 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.123 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.124 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:22  in main\0A\00", align 1
@.faila.125 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.126 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.127 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:31  in main\0A\00", align 1
@.faila.128 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.129 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.130 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:43  in main\0A\00", align 1
@.faila.131 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.132 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.133 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:53  in main\0A\00", align 1
@.faila.134 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.135 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.136 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:64  in main\0A\00", align 1
@.faila.137 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.138 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.139 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:74  in main\0A\00", align 1
@.faila.140 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.141 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.142 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:84  in main\0A\00", align 1
@.faila.143 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.144 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.145 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:23:94  in main\0A\00", align 1
@.faila.146 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.147 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.148 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:23  in main\0A\00", align 1
@.faila.149 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.150 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.151 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:33  in main\0A\00", align 1
@.faila.152 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.153 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.154 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:43  in main\0A\00", align 1
@.faila.155 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.156 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.157 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:53  in main\0A\00", align 1
@.faila.158 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.159 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.160 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:64  in main\0A\00", align 1
@.faila.161 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.162 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.163 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:74  in main\0A\00", align 1
@.faila.164 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.165 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.166 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:84  in main\0A\00", align 1
@.faila.167 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.168 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.169 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:24:94  in main\0A\00", align 1
@.faila.170 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.171 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.172 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:23  in main\0A\00", align 1
@.faila.173 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.174 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.175 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:33  in main\0A\00", align 1
@.faila.176 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.177 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.178 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:43  in main\0A\00", align 1
@.faila.179 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.180 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.181 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:53  in main\0A\00", align 1
@.faila.182 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.183 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.184 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:64  in main\0A\00", align 1
@.faila.185 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.186 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.187 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:74  in main\0A\00", align 1
@.faila.188 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.189 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.190 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:84  in main\0A\00", align 1
@.faila.191 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.192 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.193 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:25:94  in main\0A\00", align 1
@.faila.194 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.195 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.196 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:26:23  in main\0A\00", align 1
@.faila.197 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.198 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.199 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/stack_vm.pol:26:33  in main\0A\00", align 1
@.faila.200 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.201 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [19 x i8] c"fact5=%d sum10=%d\0A\00", align 1
@.fail.5336 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9149:21  in StackVm.run\0A\00", align 1
@.faila.5337 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5338 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5339 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9150:21  in StackVm.run\0A\00", align 1
@.faila.5340 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5341 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5342 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9153:50  in StackVm.run\0A\00", align 1
@.faila.5343 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5344 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5345 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9154:69  in StackVm.run\0A\00", align 1
@.faila.5346 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5347 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5348 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9154:69  in StackVm.run\0A\00", align 1
@.faila.5349 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5350 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5351 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9155:57  in StackVm.run\0A\00", align 1
@.faila.5352 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5353 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5354 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9155:57  in StackVm.run\0A\00", align 1
@.faila.5355 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5356 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5357 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9156:60  in StackVm.run\0A\00", align 1
@.faila.5358 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5359 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5360 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9156:102  in StackVm.run\0A\00", align 1
@.faila.5361 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5362 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5363 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9156:102  in StackVm.run\0A\00", align 1
@.faila.5364 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5365 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5366 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9157:60  in StackVm.run\0A\00", align 1
@.faila.5367 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5368 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5369 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9157:102  in StackVm.run\0A\00", align 1
@.faila.5370 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5371 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5372 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9157:102  in StackVm.run\0A\00", align 1
@.faila.5373 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5374 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5375 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9158:60  in StackVm.run\0A\00", align 1
@.faila.5376 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5377 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5378 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9160:60  in StackVm.run\0A\00", align 1
@.faila.5379 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5380 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5381 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9160:102  in StackVm.run\0A\00", align 1
@.faila.5382 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5383 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5384 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9160:102  in StackVm.run\0A\00", align 1
@.faila.5385 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5386 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5387 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9164:31  in StackVm.run\0A\00", align 1
@.faila.5388 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5389 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5509 = private constant [1 x i8] zeroinitializer
@.strobj.5510 = private global %String { i64 0, ptr @.strdata.5509, i64 0 }
@.strdata.5511 = private constant [1 x i8] zeroinitializer
@.strobj.5512 = private global %String { i64 0, ptr @.strdata.5511, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %s = alloca i32, align 4
  %sm = alloca ptr, align 8
  %f = alloca i32, align 4
  %fac = alloca ptr, align 8
  %args = alloca ptr, align 8
  %argv.i = alloca i64, align 8
  %2 = sext i32 %0 to i64
  %3 = sub i64 %2, 1
  %4 = icmp slt i64 %3, 0
  %5 = select i1 %4, i64 0, i64 %3
  %6 = mul i64 %5, 8
  %7 = add i64 8, %6
  %argv.arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %argv.arr, align 8
  %arr.data = getelementptr i8, ptr %argv.arr, i64 8
  store i64 0, ptr %argv.i, align 8
  br label %argv.cond

argv.cond:                                        ; preds = %argv.body, %entry
  %argv.iv = load i64, ptr %argv.i, align 8
  %8 = icmp slt i64 %argv.iv, %5
  br i1 %8, label %argv.body, label %argv.end

argv.body:                                        ; preds = %argv.cond
  %9 = add i64 %argv.iv, 1
  %10 = getelementptr ptr, ptr %1, i64 %9
  %argv.s = load ptr, ptr %10, align 8
  %argv.rawlen = call i64 @strlen(ptr %argv.s)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %argv.rawlen, ptr %11, align 8
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %argv.s, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %13, align 8
  %14 = getelementptr ptr, ptr %arr.data, i64 %argv.iv
  store ptr %newstr, ptr %14, align 8
  %15 = add i64 %argv.iv, 1
  store i64 %15, ptr %argv.i, align 8
  br label %argv.cond

argv.end:                                         ; preds = %argv.cond
  store ptr %argv.arr, ptr %args, align 8
  call void @Test.__onClassLoad()
  %arr = call ptr @__polaron_malloc(i64 144)
  store i64 34, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 136)
  store ptr %arr, ptr %fac, align 8
  %fac2 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %fac2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %fac2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 1, ptr %arr.elem, align 4
  %fac4 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %fac4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %fac4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 1, ptr %arr.elem10, align 4
  %fac11 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %fac11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %fac11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 2, ptr %arr.elem17, align 4
  %fac18 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %fac18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %fac18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 0, ptr %arr.elem24, align 4
  %fac25 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %fac25, align 8
  %arr.oob27 = icmp uge i64 4, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %fac25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 4
  store i32 1, ptr %arr.elem31, align 4
  %fac32 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len33 = load i64, ptr %fac32, align 8
  %arr.oob34 = icmp uge i64 5, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 5, ptr @.failb.15, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok29
  %arr.data37 = getelementptr i8, ptr %fac32, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 5
  store i32 5, ptr %arr.elem38, align 4
  %fac39 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len40 = load i64, ptr %fac39, align 8
  %arr.oob41 = icmp uge i64 6, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !2

idx.bad42:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 6, ptr @.failb.18, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok36
  %arr.data44 = getelementptr i8, ptr %fac39, i64 8
  %arr.elem45 = getelementptr inbounds i32, ptr %arr.data44, i64 6
  store i32 2, ptr %arr.elem45, align 4
  %fac46 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len47 = load i64, ptr %fac46, align 8
  %arr.oob48 = icmp uge i64 7, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

idx.bad49:                                        ; preds = %idx.ok43
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 7, ptr @.failb.21, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok43
  %arr.data51 = getelementptr i8, ptr %fac46, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 7
  store i32 1, ptr %arr.elem52, align 4
  %fac53 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len54 = load i64, ptr %fac53, align 8
  %arr.oob55 = icmp uge i64 8, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !2

idx.bad56:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 8, ptr @.failb.24, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %idx.ok50
  %arr.data58 = getelementptr i8, ptr %fac53, i64 8
  %arr.elem59 = getelementptr inbounds i32, ptr %arr.data58, i64 8
  store i32 3, ptr %arr.elem59, align 4
  %fac60 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len61 = load i64, ptr %fac60, align 8
  %arr.oob62 = icmp uge i64 9, %arr.len61
  br i1 %arr.oob62, label %idx.bad63, label %idx.ok64, !prof !2

idx.bad63:                                        ; preds = %idx.ok57
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 9, ptr @.failb.27, i64 %arr.len61, i32 70)
  unreachable

idx.ok64:                                         ; preds = %idx.ok57
  %arr.data65 = getelementptr i8, ptr %fac60, i64 8
  %arr.elem66 = getelementptr inbounds i32, ptr %arr.data65, i64 9
  store i32 1, ptr %arr.elem66, align 4
  %fac67 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len68 = load i64, ptr %fac67, align 8
  %arr.oob69 = icmp uge i64 10, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !2

idx.bad70:                                        ; preds = %idx.ok64
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 10, ptr @.failb.30, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %idx.ok64
  %arr.data72 = getelementptr i8, ptr %fac67, i64 8
  %arr.elem73 = getelementptr inbounds i32, ptr %arr.data72, i64 10
  store i32 6, ptr %arr.elem73, align 4
  %fac74 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len75 = load i64, ptr %fac74, align 8
  %arr.oob76 = icmp uge i64 11, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

idx.bad77:                                        ; preds = %idx.ok71
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 11, ptr @.failb.33, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %idx.ok71
  %arr.data79 = getelementptr i8, ptr %fac74, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 11
  store i32 15, ptr %arr.elem80, align 4
  %fac81 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len82 = load i64, ptr %fac81, align 8
  %arr.oob83 = icmp uge i64 12, %arr.len82
  br i1 %arr.oob83, label %idx.bad84, label %idx.ok85, !prof !2

idx.bad84:                                        ; preds = %idx.ok78
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 12, ptr @.failb.36, i64 %arr.len82, i32 70)
  unreachable

idx.ok85:                                         ; preds = %idx.ok78
  %arr.data86 = getelementptr i8, ptr %fac81, i64 8
  %arr.elem87 = getelementptr inbounds i32, ptr %arr.data86, i64 12
  store i32 3, ptr %arr.elem87, align 4
  %fac88 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len89 = load i64, ptr %fac88, align 8
  %arr.oob90 = icmp uge i64 13, %arr.len89
  br i1 %arr.oob90, label %idx.bad91, label %idx.ok92, !prof !2

idx.bad91:                                        ; preds = %idx.ok85
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 13, ptr @.failb.39, i64 %arr.len89, i32 70)
  unreachable

idx.ok92:                                         ; preds = %idx.ok85
  %arr.data93 = getelementptr i8, ptr %fac88, i64 8
  %arr.elem94 = getelementptr inbounds i32, ptr %arr.data93, i64 13
  store i32 0, ptr %arr.elem94, align 4
  %fac95 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len96 = load i64, ptr %fac95, align 8
  %arr.oob97 = icmp uge i64 14, %arr.len96
  br i1 %arr.oob97, label %idx.bad98, label %idx.ok99, !prof !2

idx.bad98:                                        ; preds = %idx.ok92
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 14, ptr @.failb.42, i64 %arr.len96, i32 70)
  unreachable

idx.ok99:                                         ; preds = %idx.ok92
  %arr.data100 = getelementptr i8, ptr %fac95, i64 8
  %arr.elem101 = getelementptr inbounds i32, ptr %arr.data100, i64 14
  store i32 3, ptr %arr.elem101, align 4
  %fac102 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len103 = load i64, ptr %fac102, align 8
  %arr.oob104 = icmp uge i64 15, %arr.len103
  br i1 %arr.oob104, label %idx.bad105, label %idx.ok106, !prof !2

idx.bad105:                                       ; preds = %idx.ok99
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 15, ptr @.failb.45, i64 %arr.len103, i32 70)
  unreachable

idx.ok106:                                        ; preds = %idx.ok99
  %arr.data107 = getelementptr i8, ptr %fac102, i64 8
  %arr.elem108 = getelementptr inbounds i32, ptr %arr.data107, i64 15
  store i32 1, ptr %arr.elem108, align 4
  %fac109 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len110 = load i64, ptr %fac109, align 8
  %arr.oob111 = icmp uge i64 16, %arr.len110
  br i1 %arr.oob111, label %idx.bad112, label %idx.ok113, !prof !2

idx.bad112:                                       ; preds = %idx.ok106
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 16, ptr @.failb.48, i64 %arr.len110, i32 70)
  unreachable

idx.ok113:                                        ; preds = %idx.ok106
  %arr.data114 = getelementptr i8, ptr %fac109, i64 8
  %arr.elem115 = getelementptr inbounds i32, ptr %arr.data114, i64 16
  store i32 4, ptr %arr.elem115, align 4
  %fac116 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len117 = load i64, ptr %fac116, align 8
  %arr.oob118 = icmp uge i64 17, %arr.len117
  br i1 %arr.oob118, label %idx.bad119, label %idx.ok120, !prof !2

idx.bad119:                                       ; preds = %idx.ok113
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 17, ptr @.failb.51, i64 %arr.len117, i32 70)
  unreachable

idx.ok120:                                        ; preds = %idx.ok113
  %arr.data121 = getelementptr i8, ptr %fac116, i64 8
  %arr.elem122 = getelementptr inbounds i32, ptr %arr.data121, i64 17
  store i32 0, ptr %arr.elem122, align 4
  %fac123 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len124 = load i64, ptr %fac123, align 8
  %arr.oob125 = icmp uge i64 18, %arr.len124
  br i1 %arr.oob125, label %idx.bad126, label %idx.ok127, !prof !2

idx.bad126:                                       ; preds = %idx.ok120
  call void @__polaron_fail(ptr @.fail.52, ptr @.faila.53, i64 18, ptr @.failb.54, i64 %arr.len124, i32 70)
  unreachable

idx.ok127:                                        ; preds = %idx.ok120
  %arr.data128 = getelementptr i8, ptr %fac123, i64 8
  %arr.elem129 = getelementptr inbounds i32, ptr %arr.data128, i64 18
  store i32 2, ptr %arr.elem129, align 4
  %fac130 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len131 = load i64, ptr %fac130, align 8
  %arr.oob132 = icmp uge i64 19, %arr.len131
  br i1 %arr.oob132, label %idx.bad133, label %idx.ok134, !prof !2

idx.bad133:                                       ; preds = %idx.ok127
  call void @__polaron_fail(ptr @.fail.55, ptr @.faila.56, i64 19, ptr @.failb.57, i64 %arr.len131, i32 70)
  unreachable

idx.ok134:                                        ; preds = %idx.ok127
  %arr.data135 = getelementptr i8, ptr %fac130, i64 8
  %arr.elem136 = getelementptr inbounds i32, ptr %arr.data135, i64 19
  store i32 0, ptr %arr.elem136, align 4
  %fac137 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len138 = load i64, ptr %fac137, align 8
  %arr.oob139 = icmp uge i64 20, %arr.len138
  br i1 %arr.oob139, label %idx.bad140, label %idx.ok141, !prof !2

idx.bad140:                                       ; preds = %idx.ok134
  call void @__polaron_fail(ptr @.fail.58, ptr @.faila.59, i64 20, ptr @.failb.60, i64 %arr.len138, i32 70)
  unreachable

idx.ok141:                                        ; preds = %idx.ok134
  %arr.data142 = getelementptr i8, ptr %fac137, i64 8
  %arr.elem143 = getelementptr inbounds i32, ptr %arr.data142, i64 20
  store i32 3, ptr %arr.elem143, align 4
  %fac144 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len145 = load i64, ptr %fac144, align 8
  %arr.oob146 = icmp uge i64 21, %arr.len145
  br i1 %arr.oob146, label %idx.bad147, label %idx.ok148, !prof !2

idx.bad147:                                       ; preds = %idx.ok141
  call void @__polaron_fail(ptr @.fail.61, ptr @.faila.62, i64 21, ptr @.failb.63, i64 %arr.len145, i32 70)
  unreachable

idx.ok148:                                        ; preds = %idx.ok141
  %arr.data149 = getelementptr i8, ptr %fac144, i64 8
  %arr.elem150 = getelementptr inbounds i32, ptr %arr.data149, i64 21
  store i32 1, ptr %arr.elem150, align 4
  %fac151 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len152 = load i64, ptr %fac151, align 8
  %arr.oob153 = icmp uge i64 22, %arr.len152
  br i1 %arr.oob153, label %idx.bad154, label %idx.ok155, !prof !2

idx.bad154:                                       ; preds = %idx.ok148
  call void @__polaron_fail(ptr @.fail.64, ptr @.faila.65, i64 22, ptr @.failb.66, i64 %arr.len152, i32 70)
  unreachable

idx.ok155:                                        ; preds = %idx.ok148
  %arr.data156 = getelementptr i8, ptr %fac151, i64 8
  %arr.elem157 = getelementptr inbounds i32, ptr %arr.data156, i64 22
  store i32 1, ptr %arr.elem157, align 4
  %fac158 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len159 = load i64, ptr %fac158, align 8
  %arr.oob160 = icmp uge i64 23, %arr.len159
  br i1 %arr.oob160, label %idx.bad161, label %idx.ok162, !prof !2

idx.bad161:                                       ; preds = %idx.ok155
  call void @__polaron_fail(ptr @.fail.67, ptr @.faila.68, i64 23, ptr @.failb.69, i64 %arr.len159, i32 70)
  unreachable

idx.ok162:                                        ; preds = %idx.ok155
  %arr.data163 = getelementptr i8, ptr %fac158, i64 8
  %arr.elem164 = getelementptr inbounds i32, ptr %arr.data163, i64 23
  store i32 1, ptr %arr.elem164, align 4
  %fac165 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len166 = load i64, ptr %fac165, align 8
  %arr.oob167 = icmp uge i64 24, %arr.len166
  br i1 %arr.oob167, label %idx.bad168, label %idx.ok169, !prof !2

idx.bad168:                                       ; preds = %idx.ok162
  call void @__polaron_fail(ptr @.fail.70, ptr @.faila.71, i64 24, ptr @.failb.72, i64 %arr.len166, i32 70)
  unreachable

idx.ok169:                                        ; preds = %idx.ok162
  %arr.data170 = getelementptr i8, ptr %fac165, i64 8
  %arr.elem171 = getelementptr inbounds i32, ptr %arr.data170, i64 24
  store i32 5, ptr %arr.elem171, align 4
  %fac172 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len173 = load i64, ptr %fac172, align 8
  %arr.oob174 = icmp uge i64 25, %arr.len173
  br i1 %arr.oob174, label %idx.bad175, label %idx.ok176, !prof !2

idx.bad175:                                       ; preds = %idx.ok169
  call void @__polaron_fail(ptr @.fail.73, ptr @.faila.74, i64 25, ptr @.failb.75, i64 %arr.len173, i32 70)
  unreachable

idx.ok176:                                        ; preds = %idx.ok169
  %arr.data177 = getelementptr i8, ptr %fac172, i64 8
  %arr.elem178 = getelementptr inbounds i32, ptr %arr.data177, i64 25
  store i32 0, ptr %arr.elem178, align 4
  %fac179 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len180 = load i64, ptr %fac179, align 8
  %arr.oob181 = icmp uge i64 26, %arr.len180
  br i1 %arr.oob181, label %idx.bad182, label %idx.ok183, !prof !2

idx.bad182:                                       ; preds = %idx.ok176
  call void @__polaron_fail(ptr @.fail.76, ptr @.faila.77, i64 26, ptr @.failb.78, i64 %arr.len180, i32 70)
  unreachable

idx.ok183:                                        ; preds = %idx.ok176
  %arr.data184 = getelementptr i8, ptr %fac179, i64 8
  %arr.elem185 = getelementptr inbounds i32, ptr %arr.data184, i64 26
  store i32 2, ptr %arr.elem185, align 4
  %fac186 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len187 = load i64, ptr %fac186, align 8
  %arr.oob188 = icmp uge i64 27, %arr.len187
  br i1 %arr.oob188, label %idx.bad189, label %idx.ok190, !prof !2

idx.bad189:                                       ; preds = %idx.ok183
  call void @__polaron_fail(ptr @.fail.79, ptr @.faila.80, i64 27, ptr @.failb.81, i64 %arr.len187, i32 70)
  unreachable

idx.ok190:                                        ; preds = %idx.ok183
  %arr.data191 = getelementptr i8, ptr %fac186, i64 8
  %arr.elem192 = getelementptr inbounds i32, ptr %arr.data191, i64 27
  store i32 1, ptr %arr.elem192, align 4
  %fac193 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len194 = load i64, ptr %fac193, align 8
  %arr.oob195 = icmp uge i64 28, %arr.len194
  br i1 %arr.oob195, label %idx.bad196, label %idx.ok197, !prof !2

idx.bad196:                                       ; preds = %idx.ok190
  call void @__polaron_fail(ptr @.fail.82, ptr @.faila.83, i64 28, ptr @.failb.84, i64 %arr.len194, i32 70)
  unreachable

idx.ok197:                                        ; preds = %idx.ok190
  %arr.data198 = getelementptr i8, ptr %fac193, i64 8
  %arr.elem199 = getelementptr inbounds i32, ptr %arr.data198, i64 28
  store i32 7, ptr %arr.elem199, align 4
  %fac200 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len201 = load i64, ptr %fac200, align 8
  %arr.oob202 = icmp uge i64 29, %arr.len201
  br i1 %arr.oob202, label %idx.bad203, label %idx.ok204, !prof !2

idx.bad203:                                       ; preds = %idx.ok197
  call void @__polaron_fail(ptr @.fail.85, ptr @.faila.86, i64 29, ptr @.failb.87, i64 %arr.len201, i32 70)
  unreachable

idx.ok204:                                        ; preds = %idx.ok197
  %arr.data205 = getelementptr i8, ptr %fac200, i64 8
  %arr.elem206 = getelementptr inbounds i32, ptr %arr.data205, i64 29
  store i32 4, ptr %arr.elem206, align 4
  %fac207 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len208 = load i64, ptr %fac207, align 8
  %arr.oob209 = icmp uge i64 30, %arr.len208
  br i1 %arr.oob209, label %idx.bad210, label %idx.ok211, !prof !2

idx.bad210:                                       ; preds = %idx.ok204
  call void @__polaron_fail(ptr @.fail.88, ptr @.faila.89, i64 30, ptr @.failb.90, i64 %arr.len208, i32 70)
  unreachable

idx.ok211:                                        ; preds = %idx.ok204
  %arr.data212 = getelementptr i8, ptr %fac207, i64 8
  %arr.elem213 = getelementptr inbounds i32, ptr %arr.data212, i64 30
  store i32 3, ptr %arr.elem213, align 4
  %fac214 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len215 = load i64, ptr %fac214, align 8
  %arr.oob216 = icmp uge i64 31, %arr.len215
  br i1 %arr.oob216, label %idx.bad217, label %idx.ok218, !prof !2

idx.bad217:                                       ; preds = %idx.ok211
  call void @__polaron_fail(ptr @.fail.91, ptr @.faila.92, i64 31, ptr @.failb.93, i64 %arr.len215, i32 70)
  unreachable

idx.ok218:                                        ; preds = %idx.ok211
  %arr.data219 = getelementptr i8, ptr %fac214, i64 8
  %arr.elem220 = getelementptr inbounds i32, ptr %arr.data219, i64 31
  store i32 0, ptr %arr.elem220, align 4
  %fac221 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len222 = load i64, ptr %fac221, align 8
  %arr.oob223 = icmp uge i64 32, %arr.len222
  br i1 %arr.oob223, label %idx.bad224, label %idx.ok225, !prof !2

idx.bad224:                                       ; preds = %idx.ok218
  call void @__polaron_fail(ptr @.fail.94, ptr @.faila.95, i64 32, ptr @.failb.96, i64 %arr.len222, i32 70)
  unreachable

idx.ok225:                                        ; preds = %idx.ok218
  %arr.data226 = getelementptr i8, ptr %fac221, i64 8
  %arr.elem227 = getelementptr inbounds i32, ptr %arr.data226, i64 32
  store i32 0, ptr %arr.elem227, align 4
  %fac228 = load ptr, ptr %fac, align 8, !nonnull !0, !dereferenceable !1
  %arr.len229 = load i64, ptr %fac228, align 8
  %arr.oob230 = icmp uge i64 33, %arr.len229
  br i1 %arr.oob230, label %idx.bad231, label %idx.ok232, !prof !2

idx.bad231:                                       ; preds = %idx.ok225
  call void @__polaron_fail(ptr @.fail.97, ptr @.faila.98, i64 33, ptr @.failb.99, i64 %arr.len229, i32 70)
  unreachable

idx.ok232:                                        ; preds = %idx.ok225
  %arr.data233 = getelementptr i8, ptr %fac228, i64 8
  %arr.elem234 = getelementptr inbounds i32, ptr %arr.data233, i64 33
  store i32 0, ptr %arr.elem234, align 4
  %fac235 = load ptr, ptr %fac, align 8
  %17 = call i32 @StackVm.run(ptr %fac235, i32 34, i32 4)
  store i32 %17, ptr %f, align 4
  %arr236 = call ptr @__polaron_malloc(i64 144)
  store i64 34, ptr %arr236, align 8
  %arr.data237 = getelementptr i8, ptr %arr236, i64 8
  %18 = call ptr @memset(ptr %arr.data237, i32 0, i64 136)
  store ptr %arr236, ptr %sm, align 8
  %sm238 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len239 = load i64, ptr %sm238, align 8
  %arr.oob240 = icmp uge i64 0, %arr.len239
  br i1 %arr.oob240, label %idx.bad241, label %idx.ok242, !prof !2

idx.bad241:                                       ; preds = %idx.ok232
  call void @__polaron_fail(ptr @.fail.100, ptr @.faila.101, i64 0, ptr @.failb.102, i64 %arr.len239, i32 70)
  unreachable

idx.ok242:                                        ; preds = %idx.ok232
  %arr.data243 = getelementptr i8, ptr %sm238, i64 8
  %arr.elem244 = getelementptr inbounds i32, ptr %arr.data243, i64 0
  store i32 1, ptr %arr.elem244, align 4
  %sm245 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len246 = load i64, ptr %sm245, align 8
  %arr.oob247 = icmp uge i64 1, %arr.len246
  br i1 %arr.oob247, label %idx.bad248, label %idx.ok249, !prof !2

idx.bad248:                                       ; preds = %idx.ok242
  call void @__polaron_fail(ptr @.fail.103, ptr @.faila.104, i64 1, ptr @.failb.105, i64 %arr.len246, i32 70)
  unreachable

idx.ok249:                                        ; preds = %idx.ok242
  %arr.data250 = getelementptr i8, ptr %sm245, i64 8
  %arr.elem251 = getelementptr inbounds i32, ptr %arr.data250, i64 1
  store i32 0, ptr %arr.elem251, align 4
  %sm252 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len253 = load i64, ptr %sm252, align 8
  %arr.oob254 = icmp uge i64 2, %arr.len253
  br i1 %arr.oob254, label %idx.bad255, label %idx.ok256, !prof !2

idx.bad255:                                       ; preds = %idx.ok249
  call void @__polaron_fail(ptr @.fail.106, ptr @.faila.107, i64 2, ptr @.failb.108, i64 %arr.len253, i32 70)
  unreachable

idx.ok256:                                        ; preds = %idx.ok249
  %arr.data257 = getelementptr i8, ptr %sm252, i64 8
  %arr.elem258 = getelementptr inbounds i32, ptr %arr.data257, i64 2
  store i32 2, ptr %arr.elem258, align 4
  %sm259 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len260 = load i64, ptr %sm259, align 8
  %arr.oob261 = icmp uge i64 3, %arr.len260
  br i1 %arr.oob261, label %idx.bad262, label %idx.ok263, !prof !2

idx.bad262:                                       ; preds = %idx.ok256
  call void @__polaron_fail(ptr @.fail.109, ptr @.faila.110, i64 3, ptr @.failb.111, i64 %arr.len260, i32 70)
  unreachable

idx.ok263:                                        ; preds = %idx.ok256
  %arr.data264 = getelementptr i8, ptr %sm259, i64 8
  %arr.elem265 = getelementptr inbounds i32, ptr %arr.data264, i64 3
  store i32 0, ptr %arr.elem265, align 4
  %sm266 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len267 = load i64, ptr %sm266, align 8
  %arr.oob268 = icmp uge i64 4, %arr.len267
  br i1 %arr.oob268, label %idx.bad269, label %idx.ok270, !prof !2

idx.bad269:                                       ; preds = %idx.ok263
  call void @__polaron_fail(ptr @.fail.112, ptr @.faila.113, i64 4, ptr @.failb.114, i64 %arr.len267, i32 70)
  unreachable

idx.ok270:                                        ; preds = %idx.ok263
  %arr.data271 = getelementptr i8, ptr %sm266, i64 8
  %arr.elem272 = getelementptr inbounds i32, ptr %arr.data271, i64 4
  store i32 1, ptr %arr.elem272, align 4
  %sm273 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len274 = load i64, ptr %sm273, align 8
  %arr.oob275 = icmp uge i64 5, %arr.len274
  br i1 %arr.oob275, label %idx.bad276, label %idx.ok277, !prof !2

idx.bad276:                                       ; preds = %idx.ok270
  call void @__polaron_fail(ptr @.fail.115, ptr @.faila.116, i64 5, ptr @.failb.117, i64 %arr.len274, i32 70)
  unreachable

idx.ok277:                                        ; preds = %idx.ok270
  %arr.data278 = getelementptr i8, ptr %sm273, i64 8
  %arr.elem279 = getelementptr inbounds i32, ptr %arr.data278, i64 5
  store i32 10, ptr %arr.elem279, align 4
  %sm280 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len281 = load i64, ptr %sm280, align 8
  %arr.oob282 = icmp uge i64 6, %arr.len281
  br i1 %arr.oob282, label %idx.bad283, label %idx.ok284, !prof !2

idx.bad283:                                       ; preds = %idx.ok277
  call void @__polaron_fail(ptr @.fail.118, ptr @.faila.119, i64 6, ptr @.failb.120, i64 %arr.len281, i32 70)
  unreachable

idx.ok284:                                        ; preds = %idx.ok277
  %arr.data285 = getelementptr i8, ptr %sm280, i64 8
  %arr.elem286 = getelementptr inbounds i32, ptr %arr.data285, i64 6
  store i32 2, ptr %arr.elem286, align 4
  %sm287 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len288 = load i64, ptr %sm287, align 8
  %arr.oob289 = icmp uge i64 7, %arr.len288
  br i1 %arr.oob289, label %idx.bad290, label %idx.ok291, !prof !2

idx.bad290:                                       ; preds = %idx.ok284
  call void @__polaron_fail(ptr @.fail.121, ptr @.faila.122, i64 7, ptr @.failb.123, i64 %arr.len288, i32 70)
  unreachable

idx.ok291:                                        ; preds = %idx.ok284
  %arr.data292 = getelementptr i8, ptr %sm287, i64 8
  %arr.elem293 = getelementptr inbounds i32, ptr %arr.data292, i64 7
  store i32 1, ptr %arr.elem293, align 4
  %sm294 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len295 = load i64, ptr %sm294, align 8
  %arr.oob296 = icmp uge i64 8, %arr.len295
  br i1 %arr.oob296, label %idx.bad297, label %idx.ok298, !prof !2

idx.bad297:                                       ; preds = %idx.ok291
  call void @__polaron_fail(ptr @.fail.124, ptr @.faila.125, i64 8, ptr @.failb.126, i64 %arr.len295, i32 70)
  unreachable

idx.ok298:                                        ; preds = %idx.ok291
  %arr.data299 = getelementptr i8, ptr %sm294, i64 8
  %arr.elem300 = getelementptr inbounds i32, ptr %arr.data299, i64 8
  store i32 3, ptr %arr.elem300, align 4
  %sm301 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len302 = load i64, ptr %sm301, align 8
  %arr.oob303 = icmp uge i64 9, %arr.len302
  br i1 %arr.oob303, label %idx.bad304, label %idx.ok305, !prof !2

idx.bad304:                                       ; preds = %idx.ok298
  call void @__polaron_fail(ptr @.fail.127, ptr @.faila.128, i64 9, ptr @.failb.129, i64 %arr.len302, i32 70)
  unreachable

idx.ok305:                                        ; preds = %idx.ok298
  %arr.data306 = getelementptr i8, ptr %sm301, i64 8
  %arr.elem307 = getelementptr inbounds i32, ptr %arr.data306, i64 9
  store i32 1, ptr %arr.elem307, align 4
  %sm308 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len309 = load i64, ptr %sm308, align 8
  %arr.oob310 = icmp uge i64 10, %arr.len309
  br i1 %arr.oob310, label %idx.bad311, label %idx.ok312, !prof !2

idx.bad311:                                       ; preds = %idx.ok305
  call void @__polaron_fail(ptr @.fail.130, ptr @.faila.131, i64 10, ptr @.failb.132, i64 %arr.len309, i32 70)
  unreachable

idx.ok312:                                        ; preds = %idx.ok305
  %arr.data313 = getelementptr i8, ptr %sm308, i64 8
  %arr.elem314 = getelementptr inbounds i32, ptr %arr.data313, i64 10
  store i32 6, ptr %arr.elem314, align 4
  %sm315 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len316 = load i64, ptr %sm315, align 8
  %arr.oob317 = icmp uge i64 11, %arr.len316
  br i1 %arr.oob317, label %idx.bad318, label %idx.ok319, !prof !2

idx.bad318:                                       ; preds = %idx.ok312
  call void @__polaron_fail(ptr @.fail.133, ptr @.faila.134, i64 11, ptr @.failb.135, i64 %arr.len316, i32 70)
  unreachable

idx.ok319:                                        ; preds = %idx.ok312
  %arr.data320 = getelementptr i8, ptr %sm315, i64 8
  %arr.elem321 = getelementptr inbounds i32, ptr %arr.data320, i64 11
  store i32 15, ptr %arr.elem321, align 4
  %sm322 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len323 = load i64, ptr %sm322, align 8
  %arr.oob324 = icmp uge i64 12, %arr.len323
  br i1 %arr.oob324, label %idx.bad325, label %idx.ok326, !prof !2

idx.bad325:                                       ; preds = %idx.ok319
  call void @__polaron_fail(ptr @.fail.136, ptr @.faila.137, i64 12, ptr @.failb.138, i64 %arr.len323, i32 70)
  unreachable

idx.ok326:                                        ; preds = %idx.ok319
  %arr.data327 = getelementptr i8, ptr %sm322, i64 8
  %arr.elem328 = getelementptr inbounds i32, ptr %arr.data327, i64 12
  store i32 3, ptr %arr.elem328, align 4
  %sm329 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len330 = load i64, ptr %sm329, align 8
  %arr.oob331 = icmp uge i64 13, %arr.len330
  br i1 %arr.oob331, label %idx.bad332, label %idx.ok333, !prof !2

idx.bad332:                                       ; preds = %idx.ok326
  call void @__polaron_fail(ptr @.fail.139, ptr @.faila.140, i64 13, ptr @.failb.141, i64 %arr.len330, i32 70)
  unreachable

idx.ok333:                                        ; preds = %idx.ok326
  %arr.data334 = getelementptr i8, ptr %sm329, i64 8
  %arr.elem335 = getelementptr inbounds i32, ptr %arr.data334, i64 13
  store i32 0, ptr %arr.elem335, align 4
  %sm336 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len337 = load i64, ptr %sm336, align 8
  %arr.oob338 = icmp uge i64 14, %arr.len337
  br i1 %arr.oob338, label %idx.bad339, label %idx.ok340, !prof !2

idx.bad339:                                       ; preds = %idx.ok333
  call void @__polaron_fail(ptr @.fail.142, ptr @.faila.143, i64 14, ptr @.failb.144, i64 %arr.len337, i32 70)
  unreachable

idx.ok340:                                        ; preds = %idx.ok333
  %arr.data341 = getelementptr i8, ptr %sm336, i64 8
  %arr.elem342 = getelementptr inbounds i32, ptr %arr.data341, i64 14
  store i32 3, ptr %arr.elem342, align 4
  %sm343 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len344 = load i64, ptr %sm343, align 8
  %arr.oob345 = icmp uge i64 15, %arr.len344
  br i1 %arr.oob345, label %idx.bad346, label %idx.ok347, !prof !2

idx.bad346:                                       ; preds = %idx.ok340
  call void @__polaron_fail(ptr @.fail.145, ptr @.faila.146, i64 15, ptr @.failb.147, i64 %arr.len344, i32 70)
  unreachable

idx.ok347:                                        ; preds = %idx.ok340
  %arr.data348 = getelementptr i8, ptr %sm343, i64 8
  %arr.elem349 = getelementptr inbounds i32, ptr %arr.data348, i64 15
  store i32 1, ptr %arr.elem349, align 4
  %sm350 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len351 = load i64, ptr %sm350, align 8
  %arr.oob352 = icmp uge i64 16, %arr.len351
  br i1 %arr.oob352, label %idx.bad353, label %idx.ok354, !prof !2

idx.bad353:                                       ; preds = %idx.ok347
  call void @__polaron_fail(ptr @.fail.148, ptr @.faila.149, i64 16, ptr @.failb.150, i64 %arr.len351, i32 70)
  unreachable

idx.ok354:                                        ; preds = %idx.ok347
  %arr.data355 = getelementptr i8, ptr %sm350, i64 8
  %arr.elem356 = getelementptr inbounds i32, ptr %arr.data355, i64 16
  store i32 8, ptr %arr.elem356, align 4
  %sm357 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len358 = load i64, ptr %sm357, align 8
  %arr.oob359 = icmp uge i64 17, %arr.len358
  br i1 %arr.oob359, label %idx.bad360, label %idx.ok361, !prof !2

idx.bad360:                                       ; preds = %idx.ok354
  call void @__polaron_fail(ptr @.fail.151, ptr @.faila.152, i64 17, ptr @.failb.153, i64 %arr.len358, i32 70)
  unreachable

idx.ok361:                                        ; preds = %idx.ok354
  %arr.data362 = getelementptr i8, ptr %sm357, i64 8
  %arr.elem363 = getelementptr inbounds i32, ptr %arr.data362, i64 17
  store i32 0, ptr %arr.elem363, align 4
  %sm364 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len365 = load i64, ptr %sm364, align 8
  %arr.oob366 = icmp uge i64 18, %arr.len365
  br i1 %arr.oob366, label %idx.bad367, label %idx.ok368, !prof !2

idx.bad367:                                       ; preds = %idx.ok361
  call void @__polaron_fail(ptr @.fail.154, ptr @.faila.155, i64 18, ptr @.failb.156, i64 %arr.len365, i32 70)
  unreachable

idx.ok368:                                        ; preds = %idx.ok361
  %arr.data369 = getelementptr i8, ptr %sm364, i64 8
  %arr.elem370 = getelementptr inbounds i32, ptr %arr.data369, i64 18
  store i32 2, ptr %arr.elem370, align 4
  %sm371 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len372 = load i64, ptr %sm371, align 8
  %arr.oob373 = icmp uge i64 19, %arr.len372
  br i1 %arr.oob373, label %idx.bad374, label %idx.ok375, !prof !2

idx.bad374:                                       ; preds = %idx.ok368
  call void @__polaron_fail(ptr @.fail.157, ptr @.faila.158, i64 19, ptr @.failb.159, i64 %arr.len372, i32 70)
  unreachable

idx.ok375:                                        ; preds = %idx.ok368
  %arr.data376 = getelementptr i8, ptr %sm371, i64 8
  %arr.elem377 = getelementptr inbounds i32, ptr %arr.data376, i64 19
  store i32 0, ptr %arr.elem377, align 4
  %sm378 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len379 = load i64, ptr %sm378, align 8
  %arr.oob380 = icmp uge i64 20, %arr.len379
  br i1 %arr.oob380, label %idx.bad381, label %idx.ok382, !prof !2

idx.bad381:                                       ; preds = %idx.ok375
  call void @__polaron_fail(ptr @.fail.160, ptr @.faila.161, i64 20, ptr @.failb.162, i64 %arr.len379, i32 70)
  unreachable

idx.ok382:                                        ; preds = %idx.ok375
  %arr.data383 = getelementptr i8, ptr %sm378, i64 8
  %arr.elem384 = getelementptr inbounds i32, ptr %arr.data383, i64 20
  store i32 3, ptr %arr.elem384, align 4
  %sm385 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len386 = load i64, ptr %sm385, align 8
  %arr.oob387 = icmp uge i64 21, %arr.len386
  br i1 %arr.oob387, label %idx.bad388, label %idx.ok389, !prof !2

idx.bad388:                                       ; preds = %idx.ok382
  call void @__polaron_fail(ptr @.fail.163, ptr @.faila.164, i64 21, ptr @.failb.165, i64 %arr.len386, i32 70)
  unreachable

idx.ok389:                                        ; preds = %idx.ok382
  %arr.data390 = getelementptr i8, ptr %sm385, i64 8
  %arr.elem391 = getelementptr inbounds i32, ptr %arr.data390, i64 21
  store i32 1, ptr %arr.elem391, align 4
  %sm392 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len393 = load i64, ptr %sm392, align 8
  %arr.oob394 = icmp uge i64 22, %arr.len393
  br i1 %arr.oob394, label %idx.bad395, label %idx.ok396, !prof !2

idx.bad395:                                       ; preds = %idx.ok389
  call void @__polaron_fail(ptr @.fail.166, ptr @.faila.167, i64 22, ptr @.failb.168, i64 %arr.len393, i32 70)
  unreachable

idx.ok396:                                        ; preds = %idx.ok389
  %arr.data397 = getelementptr i8, ptr %sm392, i64 8
  %arr.elem398 = getelementptr inbounds i32, ptr %arr.data397, i64 22
  store i32 1, ptr %arr.elem398, align 4
  %sm399 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len400 = load i64, ptr %sm399, align 8
  %arr.oob401 = icmp uge i64 23, %arr.len400
  br i1 %arr.oob401, label %idx.bad402, label %idx.ok403, !prof !2

idx.bad402:                                       ; preds = %idx.ok396
  call void @__polaron_fail(ptr @.fail.169, ptr @.faila.170, i64 23, ptr @.failb.171, i64 %arr.len400, i32 70)
  unreachable

idx.ok403:                                        ; preds = %idx.ok396
  %arr.data404 = getelementptr i8, ptr %sm399, i64 8
  %arr.elem405 = getelementptr inbounds i32, ptr %arr.data404, i64 23
  store i32 1, ptr %arr.elem405, align 4
  %sm406 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len407 = load i64, ptr %sm406, align 8
  %arr.oob408 = icmp uge i64 24, %arr.len407
  br i1 %arr.oob408, label %idx.bad409, label %idx.ok410, !prof !2

idx.bad409:                                       ; preds = %idx.ok403
  call void @__polaron_fail(ptr @.fail.172, ptr @.faila.173, i64 24, ptr @.failb.174, i64 %arr.len407, i32 70)
  unreachable

idx.ok410:                                        ; preds = %idx.ok403
  %arr.data411 = getelementptr i8, ptr %sm406, i64 8
  %arr.elem412 = getelementptr inbounds i32, ptr %arr.data411, i64 24
  store i32 5, ptr %arr.elem412, align 4
  %sm413 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len414 = load i64, ptr %sm413, align 8
  %arr.oob415 = icmp uge i64 25, %arr.len414
  br i1 %arr.oob415, label %idx.bad416, label %idx.ok417, !prof !2

idx.bad416:                                       ; preds = %idx.ok410
  call void @__polaron_fail(ptr @.fail.175, ptr @.faila.176, i64 25, ptr @.failb.177, i64 %arr.len414, i32 70)
  unreachable

idx.ok417:                                        ; preds = %idx.ok410
  %arr.data418 = getelementptr i8, ptr %sm413, i64 8
  %arr.elem419 = getelementptr inbounds i32, ptr %arr.data418, i64 25
  store i32 0, ptr %arr.elem419, align 4
  %sm420 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len421 = load i64, ptr %sm420, align 8
  %arr.oob422 = icmp uge i64 26, %arr.len421
  br i1 %arr.oob422, label %idx.bad423, label %idx.ok424, !prof !2

idx.bad423:                                       ; preds = %idx.ok417
  call void @__polaron_fail(ptr @.fail.178, ptr @.faila.179, i64 26, ptr @.failb.180, i64 %arr.len421, i32 70)
  unreachable

idx.ok424:                                        ; preds = %idx.ok417
  %arr.data425 = getelementptr i8, ptr %sm420, i64 8
  %arr.elem426 = getelementptr inbounds i32, ptr %arr.data425, i64 26
  store i32 2, ptr %arr.elem426, align 4
  %sm427 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len428 = load i64, ptr %sm427, align 8
  %arr.oob429 = icmp uge i64 27, %arr.len428
  br i1 %arr.oob429, label %idx.bad430, label %idx.ok431, !prof !2

idx.bad430:                                       ; preds = %idx.ok424
  call void @__polaron_fail(ptr @.fail.181, ptr @.faila.182, i64 27, ptr @.failb.183, i64 %arr.len428, i32 70)
  unreachable

idx.ok431:                                        ; preds = %idx.ok424
  %arr.data432 = getelementptr i8, ptr %sm427, i64 8
  %arr.elem433 = getelementptr inbounds i32, ptr %arr.data432, i64 27
  store i32 1, ptr %arr.elem433, align 4
  %sm434 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len435 = load i64, ptr %sm434, align 8
  %arr.oob436 = icmp uge i64 28, %arr.len435
  br i1 %arr.oob436, label %idx.bad437, label %idx.ok438, !prof !2

idx.bad437:                                       ; preds = %idx.ok431
  call void @__polaron_fail(ptr @.fail.184, ptr @.faila.185, i64 28, ptr @.failb.186, i64 %arr.len435, i32 70)
  unreachable

idx.ok438:                                        ; preds = %idx.ok431
  %arr.data439 = getelementptr i8, ptr %sm434, i64 8
  %arr.elem440 = getelementptr inbounds i32, ptr %arr.data439, i64 28
  store i32 7, ptr %arr.elem440, align 4
  %sm441 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len442 = load i64, ptr %sm441, align 8
  %arr.oob443 = icmp uge i64 29, %arr.len442
  br i1 %arr.oob443, label %idx.bad444, label %idx.ok445, !prof !2

idx.bad444:                                       ; preds = %idx.ok438
  call void @__polaron_fail(ptr @.fail.187, ptr @.faila.188, i64 29, ptr @.failb.189, i64 %arr.len442, i32 70)
  unreachable

idx.ok445:                                        ; preds = %idx.ok438
  %arr.data446 = getelementptr i8, ptr %sm441, i64 8
  %arr.elem447 = getelementptr inbounds i32, ptr %arr.data446, i64 29
  store i32 4, ptr %arr.elem447, align 4
  %sm448 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len449 = load i64, ptr %sm448, align 8
  %arr.oob450 = icmp uge i64 30, %arr.len449
  br i1 %arr.oob450, label %idx.bad451, label %idx.ok452, !prof !2

idx.bad451:                                       ; preds = %idx.ok445
  call void @__polaron_fail(ptr @.fail.190, ptr @.faila.191, i64 30, ptr @.failb.192, i64 %arr.len449, i32 70)
  unreachable

idx.ok452:                                        ; preds = %idx.ok445
  %arr.data453 = getelementptr i8, ptr %sm448, i64 8
  %arr.elem454 = getelementptr inbounds i32, ptr %arr.data453, i64 30
  store i32 3, ptr %arr.elem454, align 4
  %sm455 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len456 = load i64, ptr %sm455, align 8
  %arr.oob457 = icmp uge i64 31, %arr.len456
  br i1 %arr.oob457, label %idx.bad458, label %idx.ok459, !prof !2

idx.bad458:                                       ; preds = %idx.ok452
  call void @__polaron_fail(ptr @.fail.193, ptr @.faila.194, i64 31, ptr @.failb.195, i64 %arr.len456, i32 70)
  unreachable

idx.ok459:                                        ; preds = %idx.ok452
  %arr.data460 = getelementptr i8, ptr %sm455, i64 8
  %arr.elem461 = getelementptr inbounds i32, ptr %arr.data460, i64 31
  store i32 0, ptr %arr.elem461, align 4
  %sm462 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len463 = load i64, ptr %sm462, align 8
  %arr.oob464 = icmp uge i64 32, %arr.len463
  br i1 %arr.oob464, label %idx.bad465, label %idx.ok466, !prof !2

idx.bad465:                                       ; preds = %idx.ok459
  call void @__polaron_fail(ptr @.fail.196, ptr @.faila.197, i64 32, ptr @.failb.198, i64 %arr.len463, i32 70)
  unreachable

idx.ok466:                                        ; preds = %idx.ok459
  %arr.data467 = getelementptr i8, ptr %sm462, i64 8
  %arr.elem468 = getelementptr inbounds i32, ptr %arr.data467, i64 32
  store i32 0, ptr %arr.elem468, align 4
  %sm469 = load ptr, ptr %sm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len470 = load i64, ptr %sm469, align 8
  %arr.oob471 = icmp uge i64 33, %arr.len470
  br i1 %arr.oob471, label %idx.bad472, label %idx.ok473, !prof !2

idx.bad472:                                       ; preds = %idx.ok466
  call void @__polaron_fail(ptr @.fail.199, ptr @.faila.200, i64 33, ptr @.failb.201, i64 %arr.len470, i32 70)
  unreachable

idx.ok473:                                        ; preds = %idx.ok466
  %arr.data474 = getelementptr i8, ptr %sm469, i64 8
  %arr.elem475 = getelementptr inbounds i32, ptr %arr.data474, i64 33
  store i32 0, ptr %arr.elem475, align 4
  %sm476 = load ptr, ptr %sm, align 8
  %19 = call i32 @StackVm.run(ptr %sm476, i32 34, i32 4)
  store i32 %19, ptr %s, align 4
  %f477 = load i32, ptr %f, align 4
  %s478 = load i32, ptr %s, align 4
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %f477, i32 %s478)
  ret i32 0
}

define internal i32 @StackVm.run(ptr %0, i32 %1, i32 %2) {
entry:
  %b190 = alloca i32, align 4
  %b130 = alloca i32, align 4
  %b = alloca i32, align 4
  %arg = alloca i32, align 4
  %op = alloca i32, align 4
  %running = alloca i32, align 4
  %ip = alloca i32, align 4
  %mem = alloca ptr, align 8
  %sp = alloca i32, align 4
  %stack = alloca ptr, align 8
  %memSize = alloca i32, align 4
  %plen = alloca i32, align 4
  %prog = alloca ptr, align 8
  store ptr %0, ptr %prog, align 8
  store i32 %1, ptr %plen, align 4
  store i32 %2, ptr %memSize, align 4
  %arr = call ptr @__polaron_malloc(i64 1032)
  store i64 256, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %3 = call ptr @memset(ptr %arr.data, i32 0, i64 1024)
  store ptr %arr, ptr %stack, align 8
  store i32 0, ptr %sp, align 4
  %memSize1 = load i32, ptr %memSize, align 4
  %4 = sext i32 %memSize1 to i64
  %5 = mul i64 %4, 4
  %6 = add i64 8, %5
  %arr2 = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %7 = call ptr @memset(ptr %arr.data3, i32 0, i64 %5)
  store ptr %arr2, ptr %mem, align 8
  store i32 0, ptr %ip, align 4
  store i32 1, ptr %running, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %running4 = load i32, ptr %running, align 4
  %sc.a = icmp ne i32 %running4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %prog7 = load ptr, ptr %prog, align 8, !nonnull !0, !dereferenceable !1
  %ip8 = load i32, ptr %ip, align 4
  %8 = mul i32 %ip8, 2
  %9 = sext i32 %8 to i64
  %arr.len = load i64, ptr %prog7, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %sc.end
  %sp213 = load i32, ptr %sp, align 4
  %10 = icmp sgt i32 %sp213, 0
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then214, label %if.end215

sc.rhs:                                           ; preds = %while.cond
  %ip5 = load i32, ptr %ip, align 4
  %12 = mul i32 %ip5, 2
  %plen6 = load i32, ptr %plen, align 4
  %13 = icmp slt i32 %12, %plen6
  %14 = zext i1 %13 to i32
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %15 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.5336, ptr @.faila.5337, i64 %9, ptr @.failb.5338, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data9 = getelementptr i8, ptr %prog7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 %9
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %op, align 4
  %prog10 = load ptr, ptr %prog, align 8, !nonnull !0, !dereferenceable !1
  %ip11 = load i32, ptr %ip, align 4
  %16 = mul i32 %ip11, 2
  %17 = add i32 %16, 1
  %18 = sext i32 %17 to i64
  %arr.len12 = load i64, ptr %prog10, align 8
  %arr.oob13 = icmp uge i64 %18, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5339, ptr @.faila.5340, i64 %18, ptr @.failb.5341, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %prog10, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %18
  %elem18 = load i32, ptr %arr.elem17, align 4
  store i32 %elem18, ptr %arg, align 4
  %op19 = load i32, ptr %op, align 4
  %19 = icmp eq i32 %op19, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.else

if.then:                                          ; preds = %idx.ok15
  store i32 0, ptr %running, align 4
  br label %if.end

if.else:                                          ; preds = %idx.ok15
  %op20 = load i32, ptr %op, align 4
  %21 = icmp eq i32 %op20, 1
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then21, label %if.else22

if.end:                                           ; preds = %if.end23, %if.then
  br label %while.cond

if.then21:                                        ; preds = %if.else
  %stack24 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp25 = load i32, ptr %sp, align 4
  %23 = sext i32 %sp25 to i64
  %arr.len26 = load i64, ptr %stack24, align 8
  %arr.oob27 = icmp uge i64 %23, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

if.else22:                                        ; preds = %if.else
  %op35 = load i32, ptr %op, align 4
  %24 = icmp eq i32 %op35, 2
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then36, label %if.else37

if.end23:                                         ; preds = %if.end38, %idx.ok29
  br label %if.end

idx.bad28:                                        ; preds = %if.then21
  call void @__polaron_fail(ptr @.fail.5342, ptr @.faila.5343, i64 %23, ptr @.failb.5344, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %if.then21
  %arr.data30 = getelementptr i8, ptr %stack24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %23
  %arg32 = load i32, ptr %arg, align 4
  store i32 %arg32, ptr %arr.elem31, align 4
  %sp33 = load i32, ptr %sp, align 4
  %26 = add i32 %sp33, 1
  store i32 %26, ptr %sp, align 4
  %ip34 = load i32, ptr %ip, align 4
  %27 = add i32 %ip34, 1
  store i32 %27, ptr %ip, align 4
  br label %if.end23

if.then36:                                        ; preds = %if.else22
  %sp39 = load i32, ptr %sp, align 4
  %28 = sub i32 %sp39, 1
  store i32 %28, ptr %sp, align 4
  %mem40 = load ptr, ptr %mem, align 8, !nonnull !0, !dereferenceable !1
  %arg41 = load i32, ptr %arg, align 4
  %29 = sext i32 %arg41 to i64
  %arr.len42 = load i64, ptr %mem40, align 8
  %arr.oob43 = icmp uge i64 %29, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

if.else37:                                        ; preds = %if.else22
  %op58 = load i32, ptr %op, align 4
  %30 = icmp eq i32 %op58, 3
  %31 = zext i1 %30 to i32
  br i1 %30, label %if.then59, label %if.else60

if.end38:                                         ; preds = %if.end61, %idx.ok53
  br label %if.end23

idx.bad44:                                        ; preds = %if.then36
  call void @__polaron_fail(ptr @.fail.5345, ptr @.faila.5346, i64 %29, ptr @.failb.5347, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %if.then36
  %arr.data46 = getelementptr i8, ptr %mem40, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 %29
  %stack48 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp49 = load i32, ptr %sp, align 4
  %32 = sext i32 %sp49 to i64
  %arr.len50 = load i64, ptr %stack48, align 8
  %arr.oob51 = icmp uge i64 %32, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !2

idx.bad52:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.5348, ptr @.faila.5349, i64 %32, ptr @.failb.5350, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok45
  %arr.data54 = getelementptr i8, ptr %stack48, i64 8
  %arr.elem55 = getelementptr inbounds i32, ptr %arr.data54, i64 %32
  %elem56 = load i32, ptr %arr.elem55, align 4
  store i32 %elem56, ptr %arr.elem47, align 4
  %ip57 = load i32, ptr %ip, align 4
  %33 = add i32 %ip57, 1
  store i32 %33, ptr %ip, align 4
  br label %if.end38

if.then59:                                        ; preds = %if.else37
  %stack62 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp63 = load i32, ptr %sp, align 4
  %34 = sext i32 %sp63 to i64
  %arr.len64 = load i64, ptr %stack62, align 8
  %arr.oob65 = icmp uge i64 %34, %arr.len64
  br i1 %arr.oob65, label %idx.bad66, label %idx.ok67, !prof !2

if.else60:                                        ; preds = %if.else37
  %op81 = load i32, ptr %op, align 4
  %35 = icmp eq i32 %op81, 4
  %36 = zext i1 %35 to i32
  br i1 %35, label %if.then82, label %if.else83

if.end61:                                         ; preds = %if.end84, %idx.ok75
  br label %if.end38

idx.bad66:                                        ; preds = %if.then59
  call void @__polaron_fail(ptr @.fail.5351, ptr @.faila.5352, i64 %34, ptr @.failb.5353, i64 %arr.len64, i32 70)
  unreachable

idx.ok67:                                         ; preds = %if.then59
  %arr.data68 = getelementptr i8, ptr %stack62, i64 8
  %arr.elem69 = getelementptr inbounds i32, ptr %arr.data68, i64 %34
  %mem70 = load ptr, ptr %mem, align 8, !nonnull !0, !dereferenceable !1
  %arg71 = load i32, ptr %arg, align 4
  %37 = sext i32 %arg71 to i64
  %arr.len72 = load i64, ptr %mem70, align 8
  %arr.oob73 = icmp uge i64 %37, %arr.len72
  br i1 %arr.oob73, label %idx.bad74, label %idx.ok75, !prof !2

idx.bad74:                                        ; preds = %idx.ok67
  call void @__polaron_fail(ptr @.fail.5354, ptr @.faila.5355, i64 %37, ptr @.failb.5356, i64 %arr.len72, i32 70)
  unreachable

idx.ok75:                                         ; preds = %idx.ok67
  %arr.data76 = getelementptr i8, ptr %mem70, i64 8
  %arr.elem77 = getelementptr inbounds i32, ptr %arr.data76, i64 %37
  %elem78 = load i32, ptr %arr.elem77, align 4
  store i32 %elem78, ptr %arr.elem69, align 4
  %sp79 = load i32, ptr %sp, align 4
  %38 = add i32 %sp79, 1
  store i32 %38, ptr %sp, align 4
  %ip80 = load i32, ptr %ip, align 4
  %39 = add i32 %ip80, 1
  store i32 %39, ptr %ip, align 4
  br label %if.end61

if.then82:                                        ; preds = %if.else60
  %sp85 = load i32, ptr %sp, align 4
  %40 = sub i32 %sp85, 1
  store i32 %40, ptr %sp, align 4
  %stack86 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp87 = load i32, ptr %sp, align 4
  %41 = sext i32 %sp87 to i64
  %arr.len88 = load i64, ptr %stack86, align 8
  %arr.oob89 = icmp uge i64 %41, %arr.len88
  br i1 %arr.oob89, label %idx.bad90, label %idx.ok91, !prof !2

if.else83:                                        ; preds = %if.else60
  %op116 = load i32, ptr %op, align 4
  %42 = icmp eq i32 %op116, 5
  %43 = zext i1 %42 to i32
  br i1 %42, label %if.then117, label %if.else118

if.end84:                                         ; preds = %if.end119, %idx.ok109
  br label %if.end61

idx.bad90:                                        ; preds = %if.then82
  call void @__polaron_fail(ptr @.fail.5357, ptr @.faila.5358, i64 %41, ptr @.failb.5359, i64 %arr.len88, i32 70)
  unreachable

idx.ok91:                                         ; preds = %if.then82
  %arr.data92 = getelementptr i8, ptr %stack86, i64 8
  %arr.elem93 = getelementptr inbounds i32, ptr %arr.data92, i64 %41
  %elem94 = load i32, ptr %arr.elem93, align 4
  store i32 %elem94, ptr %b, align 4
  %sp95 = load i32, ptr %sp, align 4
  %44 = sub i32 %sp95, 1
  store i32 %44, ptr %sp, align 4
  %stack96 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp97 = load i32, ptr %sp, align 4
  %45 = sext i32 %sp97 to i64
  %arr.len98 = load i64, ptr %stack96, align 8
  %arr.oob99 = icmp uge i64 %45, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !2

idx.bad100:                                       ; preds = %idx.ok91
  call void @__polaron_fail(ptr @.fail.5360, ptr @.faila.5361, i64 %45, ptr @.failb.5362, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %idx.ok91
  %arr.data102 = getelementptr i8, ptr %stack96, i64 8
  %arr.elem103 = getelementptr inbounds i32, ptr %arr.data102, i64 %45
  %stack104 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp105 = load i32, ptr %sp, align 4
  %46 = sext i32 %sp105 to i64
  %arr.len106 = load i64, ptr %stack104, align 8
  %arr.oob107 = icmp uge i64 %46, %arr.len106
  br i1 %arr.oob107, label %idx.bad108, label %idx.ok109, !prof !2

idx.bad108:                                       ; preds = %idx.ok101
  call void @__polaron_fail(ptr @.fail.5363, ptr @.faila.5364, i64 %46, ptr @.failb.5365, i64 %arr.len106, i32 70)
  unreachable

idx.ok109:                                        ; preds = %idx.ok101
  %arr.data110 = getelementptr i8, ptr %stack104, i64 8
  %arr.elem111 = getelementptr inbounds i32, ptr %arr.data110, i64 %46
  %elem112 = load i32, ptr %arr.elem111, align 4
  %b113 = load i32, ptr %b, align 4
  %47 = mul i32 %elem112, %b113
  store i32 %47, ptr %arr.elem103, align 4
  %sp114 = load i32, ptr %sp, align 4
  %48 = add i32 %sp114, 1
  store i32 %48, ptr %sp, align 4
  %ip115 = load i32, ptr %ip, align 4
  %49 = add i32 %ip115, 1
  store i32 %49, ptr %ip, align 4
  br label %if.end84

if.then117:                                       ; preds = %if.else83
  %sp120 = load i32, ptr %sp, align 4
  %50 = sub i32 %sp120, 1
  store i32 %50, ptr %sp, align 4
  %stack121 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp122 = load i32, ptr %sp, align 4
  %51 = sext i32 %sp122 to i64
  %arr.len123 = load i64, ptr %stack121, align 8
  %arr.oob124 = icmp uge i64 %51, %arr.len123
  br i1 %arr.oob124, label %idx.bad125, label %idx.ok126, !prof !2

if.else118:                                       ; preds = %if.else83
  %op152 = load i32, ptr %op, align 4
  %52 = icmp eq i32 %op152, 6
  %53 = zext i1 %52 to i32
  br i1 %52, label %if.then153, label %if.else154

if.end119:                                        ; preds = %if.end155, %idx.ok145
  br label %if.end84

idx.bad125:                                       ; preds = %if.then117
  call void @__polaron_fail(ptr @.fail.5366, ptr @.faila.5367, i64 %51, ptr @.failb.5368, i64 %arr.len123, i32 70)
  unreachable

idx.ok126:                                        ; preds = %if.then117
  %arr.data127 = getelementptr i8, ptr %stack121, i64 8
  %arr.elem128 = getelementptr inbounds i32, ptr %arr.data127, i64 %51
  %elem129 = load i32, ptr %arr.elem128, align 4
  store i32 %elem129, ptr %b130, align 4
  %sp131 = load i32, ptr %sp, align 4
  %54 = sub i32 %sp131, 1
  store i32 %54, ptr %sp, align 4
  %stack132 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp133 = load i32, ptr %sp, align 4
  %55 = sext i32 %sp133 to i64
  %arr.len134 = load i64, ptr %stack132, align 8
  %arr.oob135 = icmp uge i64 %55, %arr.len134
  br i1 %arr.oob135, label %idx.bad136, label %idx.ok137, !prof !2

idx.bad136:                                       ; preds = %idx.ok126
  call void @__polaron_fail(ptr @.fail.5369, ptr @.faila.5370, i64 %55, ptr @.failb.5371, i64 %arr.len134, i32 70)
  unreachable

idx.ok137:                                        ; preds = %idx.ok126
  %arr.data138 = getelementptr i8, ptr %stack132, i64 8
  %arr.elem139 = getelementptr inbounds i32, ptr %arr.data138, i64 %55
  %stack140 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp141 = load i32, ptr %sp, align 4
  %56 = sext i32 %sp141 to i64
  %arr.len142 = load i64, ptr %stack140, align 8
  %arr.oob143 = icmp uge i64 %56, %arr.len142
  br i1 %arr.oob143, label %idx.bad144, label %idx.ok145, !prof !2

idx.bad144:                                       ; preds = %idx.ok137
  call void @__polaron_fail(ptr @.fail.5372, ptr @.faila.5373, i64 %56, ptr @.failb.5374, i64 %arr.len142, i32 70)
  unreachable

idx.ok145:                                        ; preds = %idx.ok137
  %arr.data146 = getelementptr i8, ptr %stack140, i64 8
  %arr.elem147 = getelementptr inbounds i32, ptr %arr.data146, i64 %56
  %elem148 = load i32, ptr %arr.elem147, align 4
  %b149 = load i32, ptr %b130, align 4
  %57 = sub i32 %elem148, %b149
  store i32 %57, ptr %arr.elem139, align 4
  %sp150 = load i32, ptr %sp, align 4
  %58 = add i32 %sp150, 1
  store i32 %58, ptr %sp, align 4
  %ip151 = load i32, ptr %ip, align 4
  %59 = add i32 %ip151, 1
  store i32 %59, ptr %ip, align 4
  br label %if.end119

if.then153:                                       ; preds = %if.else118
  %sp156 = load i32, ptr %sp, align 4
  %60 = sub i32 %sp156, 1
  store i32 %60, ptr %sp, align 4
  %stack157 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp158 = load i32, ptr %sp, align 4
  %61 = sext i32 %sp158 to i64
  %arr.len159 = load i64, ptr %stack157, align 8
  %arr.oob160 = icmp uge i64 %61, %arr.len159
  br i1 %arr.oob160, label %idx.bad161, label %idx.ok162, !prof !2

if.else154:                                       ; preds = %if.else118
  %op171 = load i32, ptr %op, align 4
  %62 = icmp eq i32 %op171, 7
  %63 = zext i1 %62 to i32
  br i1 %62, label %if.then172, label %if.else173

if.end155:                                        ; preds = %if.end174, %if.end168
  br label %if.end119

idx.bad161:                                       ; preds = %if.then153
  call void @__polaron_fail(ptr @.fail.5375, ptr @.faila.5376, i64 %61, ptr @.failb.5377, i64 %arr.len159, i32 70)
  unreachable

idx.ok162:                                        ; preds = %if.then153
  %arr.data163 = getelementptr i8, ptr %stack157, i64 8
  %arr.elem164 = getelementptr inbounds i32, ptr %arr.data163, i64 %61
  %elem165 = load i32, ptr %arr.elem164, align 4
  %64 = icmp eq i32 %elem165, 0
  %65 = zext i1 %64 to i32
  br i1 %64, label %if.then166, label %if.else167

if.then166:                                       ; preds = %idx.ok162
  %arg169 = load i32, ptr %arg, align 4
  store i32 %arg169, ptr %ip, align 4
  br label %if.end168

if.else167:                                       ; preds = %idx.ok162
  %ip170 = load i32, ptr %ip, align 4
  %66 = add i32 %ip170, 1
  store i32 %66, ptr %ip, align 4
  br label %if.end168

if.end168:                                        ; preds = %if.else167, %if.then166
  br label %if.end155

if.then172:                                       ; preds = %if.else154
  %arg175 = load i32, ptr %arg, align 4
  store i32 %arg175, ptr %ip, align 4
  br label %if.end174

if.else173:                                       ; preds = %if.else154
  %op176 = load i32, ptr %op, align 4
  %67 = icmp eq i32 %op176, 8
  %68 = zext i1 %67 to i32
  br i1 %67, label %if.then177, label %if.else178

if.end174:                                        ; preds = %if.end179, %if.then172
  br label %if.end155

if.then177:                                       ; preds = %if.else173
  %sp180 = load i32, ptr %sp, align 4
  %69 = sub i32 %sp180, 1
  store i32 %69, ptr %sp, align 4
  %stack181 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp182 = load i32, ptr %sp, align 4
  %70 = sext i32 %sp182 to i64
  %arr.len183 = load i64, ptr %stack181, align 8
  %arr.oob184 = icmp uge i64 %70, %arr.len183
  br i1 %arr.oob184, label %idx.bad185, label %idx.ok186, !prof !2

if.else178:                                       ; preds = %if.else173
  %ip212 = load i32, ptr %ip, align 4
  %71 = add i32 %ip212, 1
  store i32 %71, ptr %ip, align 4
  br label %if.end179

if.end179:                                        ; preds = %if.else178, %idx.ok205
  br label %if.end174

idx.bad185:                                       ; preds = %if.then177
  call void @__polaron_fail(ptr @.fail.5378, ptr @.faila.5379, i64 %70, ptr @.failb.5380, i64 %arr.len183, i32 70)
  unreachable

idx.ok186:                                        ; preds = %if.then177
  %arr.data187 = getelementptr i8, ptr %stack181, i64 8
  %arr.elem188 = getelementptr inbounds i32, ptr %arr.data187, i64 %70
  %elem189 = load i32, ptr %arr.elem188, align 4
  store i32 %elem189, ptr %b190, align 4
  %sp191 = load i32, ptr %sp, align 4
  %72 = sub i32 %sp191, 1
  store i32 %72, ptr %sp, align 4
  %stack192 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp193 = load i32, ptr %sp, align 4
  %73 = sext i32 %sp193 to i64
  %arr.len194 = load i64, ptr %stack192, align 8
  %arr.oob195 = icmp uge i64 %73, %arr.len194
  br i1 %arr.oob195, label %idx.bad196, label %idx.ok197, !prof !2

idx.bad196:                                       ; preds = %idx.ok186
  call void @__polaron_fail(ptr @.fail.5381, ptr @.faila.5382, i64 %73, ptr @.failb.5383, i64 %arr.len194, i32 70)
  unreachable

idx.ok197:                                        ; preds = %idx.ok186
  %arr.data198 = getelementptr i8, ptr %stack192, i64 8
  %arr.elem199 = getelementptr inbounds i32, ptr %arr.data198, i64 %73
  %stack200 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp201 = load i32, ptr %sp, align 4
  %74 = sext i32 %sp201 to i64
  %arr.len202 = load i64, ptr %stack200, align 8
  %arr.oob203 = icmp uge i64 %74, %arr.len202
  br i1 %arr.oob203, label %idx.bad204, label %idx.ok205, !prof !2

idx.bad204:                                       ; preds = %idx.ok197
  call void @__polaron_fail(ptr @.fail.5384, ptr @.faila.5385, i64 %74, ptr @.failb.5386, i64 %arr.len202, i32 70)
  unreachable

idx.ok205:                                        ; preds = %idx.ok197
  %arr.data206 = getelementptr i8, ptr %stack200, i64 8
  %arr.elem207 = getelementptr inbounds i32, ptr %arr.data206, i64 %74
  %elem208 = load i32, ptr %arr.elem207, align 4
  %b209 = load i32, ptr %b190, align 4
  %75 = add i32 %elem208, %b209
  store i32 %75, ptr %arr.elem199, align 4
  %sp210 = load i32, ptr %sp, align 4
  %76 = add i32 %sp210, 1
  store i32 %76, ptr %sp, align 4
  %ip211 = load i32, ptr %ip, align 4
  %77 = add i32 %ip211, 1
  store i32 %77, ptr %ip, align 4
  br label %if.end179

if.then214:                                       ; preds = %while.end
  %stack216 = load ptr, ptr %stack, align 8, !nonnull !0, !dereferenceable !1
  %sp217 = load i32, ptr %sp, align 4
  %78 = sub i32 %sp217, 1
  %79 = sext i32 %78 to i64
  %arr.len218 = load i64, ptr %stack216, align 8
  %arr.oob219 = icmp uge i64 %79, %arr.len218
  br i1 %arr.oob219, label %idx.bad220, label %idx.ok221, !prof !2

if.end215:                                        ; preds = %while.end
  ret i32 0

idx.bad220:                                       ; preds = %if.then214
  call void @__polaron_fail(ptr @.fail.5387, ptr @.faila.5388, i64 %79, ptr @.failb.5389, i64 %arr.len218, i32 70)
  unreachable

idx.ok221:                                        ; preds = %if.then214
  %arr.data222 = getelementptr i8, ptr %stack216, i64 8
  %arr.elem223 = getelementptr inbounds i32, ptr %arr.data222, i64 %79
  %elem224 = load i32, ptr %arr.elem223, align 4
  ret i32 %elem224
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5510)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5512)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
