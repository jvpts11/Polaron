; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/simd_mat4.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/simd_mat4.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [26 x i8] c"tp=%d%d%d q=%d%d%d m2=%d\0A\00", align 1
@.panic = private unnamed_addr constant [27 x i8] c"vector index out of bounds\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %m2 = alloca <16 x float>, align 64
  %q = alloca <4 x float>, align 16
  %t = alloca <16 x float>, align 64
  %tp = alloca <4 x float>, align 16
  %p = alloca <4 x float>, align 16
  %id = alloca <16 x float>, align 64
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
  store <16 x float> <float 1.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+00>, ptr %id, align 64
  store <4 x float> <float 1.000000e+00, float 2.000000e+00, float 3.000000e+00, float 1.000000e+00>, ptr %p, align 16
  %id1 = load <16 x float>, ptr %id, align 64
  %p2 = load <4 x float>, ptr %p, align 16
  %16 = extractelement <4 x float> %p2, i32 0
  %17 = extractelement <16 x float> %id1, i32 0
  %18 = fmul float %17, %16
  %19 = fadd float 0.000000e+00, %18
  %20 = extractelement <4 x float> %p2, i32 1
  %21 = extractelement <16 x float> %id1, i32 1
  %22 = fmul float %21, %20
  %23 = fadd float %19, %22
  %24 = extractelement <4 x float> %p2, i32 2
  %25 = extractelement <16 x float> %id1, i32 2
  %26 = fmul float %25, %24
  %27 = fadd float %23, %26
  %28 = extractelement <4 x float> %p2, i32 3
  %29 = extractelement <16 x float> %id1, i32 3
  %30 = fmul float %29, %28
  %31 = fadd float %27, %30
  %32 = insertelement <4 x float> zeroinitializer, float %31, i32 0
  %33 = extractelement <4 x float> %p2, i32 0
  %34 = extractelement <16 x float> %id1, i32 4
  %35 = fmul float %34, %33
  %36 = fadd float 0.000000e+00, %35
  %37 = extractelement <4 x float> %p2, i32 1
  %38 = extractelement <16 x float> %id1, i32 5
  %39 = fmul float %38, %37
  %40 = fadd float %36, %39
  %41 = extractelement <4 x float> %p2, i32 2
  %42 = extractelement <16 x float> %id1, i32 6
  %43 = fmul float %42, %41
  %44 = fadd float %40, %43
  %45 = extractelement <4 x float> %p2, i32 3
  %46 = extractelement <16 x float> %id1, i32 7
  %47 = fmul float %46, %45
  %48 = fadd float %44, %47
  %49 = insertelement <4 x float> %32, float %48, i32 1
  %50 = extractelement <4 x float> %p2, i32 0
  %51 = extractelement <16 x float> %id1, i32 8
  %52 = fmul float %51, %50
  %53 = fadd float 0.000000e+00, %52
  %54 = extractelement <4 x float> %p2, i32 1
  %55 = extractelement <16 x float> %id1, i32 9
  %56 = fmul float %55, %54
  %57 = fadd float %53, %56
  %58 = extractelement <4 x float> %p2, i32 2
  %59 = extractelement <16 x float> %id1, i32 10
  %60 = fmul float %59, %58
  %61 = fadd float %57, %60
  %62 = extractelement <4 x float> %p2, i32 3
  %63 = extractelement <16 x float> %id1, i32 11
  %64 = fmul float %63, %62
  %65 = fadd float %61, %64
  %66 = insertelement <4 x float> %49, float %65, i32 2
  %67 = extractelement <4 x float> %p2, i32 0
  %68 = extractelement <16 x float> %id1, i32 12
  %69 = fmul float %68, %67
  %70 = fadd float 0.000000e+00, %69
  %71 = extractelement <4 x float> %p2, i32 1
  %72 = extractelement <16 x float> %id1, i32 13
  %73 = fmul float %72, %71
  %74 = fadd float %70, %73
  %75 = extractelement <4 x float> %p2, i32 2
  %76 = extractelement <16 x float> %id1, i32 14
  %77 = fmul float %76, %75
  %78 = fadd float %74, %77
  %79 = extractelement <4 x float> %p2, i32 3
  %80 = extractelement <16 x float> %id1, i32 15
  %81 = fmul float %80, %79
  %82 = fadd float %78, %81
  %83 = insertelement <4 x float> %66, float %82, i32 3
  store <4 x float> %83, ptr %tp, align 16
  store <16 x float> <float 1.000000e+00, float 0.000000e+00, float 0.000000e+00, float 5.000000e+00, float 0.000000e+00, float 1.000000e+00, float 0.000000e+00, float 6.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+00, float 7.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+00>, ptr %t, align 64
  %t3 = load <16 x float>, ptr %t, align 64
  %84 = extractelement <16 x float> %t3, i32 0
  %85 = fmul float %84, 0.000000e+00
  %86 = fadd float 0.000000e+00, %85
  %87 = extractelement <16 x float> %t3, i32 1
  %88 = fmul float %87, 0.000000e+00
  %89 = fadd float %86, %88
  %90 = extractelement <16 x float> %t3, i32 2
  %91 = fmul float %90, 0.000000e+00
  %92 = fadd float %89, %91
  %93 = extractelement <16 x float> %t3, i32 3
  %94 = fmul float %93, 1.000000e+00
  %95 = fadd float %92, %94
  %96 = insertelement <4 x float> zeroinitializer, float %95, i32 0
  %97 = extractelement <16 x float> %t3, i32 4
  %98 = fmul float %97, 0.000000e+00
  %99 = fadd float 0.000000e+00, %98
  %100 = extractelement <16 x float> %t3, i32 5
  %101 = fmul float %100, 0.000000e+00
  %102 = fadd float %99, %101
  %103 = extractelement <16 x float> %t3, i32 6
  %104 = fmul float %103, 0.000000e+00
  %105 = fadd float %102, %104
  %106 = extractelement <16 x float> %t3, i32 7
  %107 = fmul float %106, 1.000000e+00
  %108 = fadd float %105, %107
  %109 = insertelement <4 x float> %96, float %108, i32 1
  %110 = extractelement <16 x float> %t3, i32 8
  %111 = fmul float %110, 0.000000e+00
  %112 = fadd float 0.000000e+00, %111
  %113 = extractelement <16 x float> %t3, i32 9
  %114 = fmul float %113, 0.000000e+00
  %115 = fadd float %112, %114
  %116 = extractelement <16 x float> %t3, i32 10
  %117 = fmul float %116, 0.000000e+00
  %118 = fadd float %115, %117
  %119 = extractelement <16 x float> %t3, i32 11
  %120 = fmul float %119, 1.000000e+00
  %121 = fadd float %118, %120
  %122 = insertelement <4 x float> %109, float %121, i32 2
  %123 = extractelement <16 x float> %t3, i32 12
  %124 = fmul float %123, 0.000000e+00
  %125 = fadd float 0.000000e+00, %124
  %126 = extractelement <16 x float> %t3, i32 13
  %127 = fmul float %126, 0.000000e+00
  %128 = fadd float %125, %127
  %129 = extractelement <16 x float> %t3, i32 14
  %130 = fmul float %129, 0.000000e+00
  %131 = fadd float %128, %130
  %132 = extractelement <16 x float> %t3, i32 15
  %133 = fmul float %132, 1.000000e+00
  %134 = fadd float %131, %133
  %135 = insertelement <4 x float> %122, float %134, i32 3
  store <4 x float> %135, ptr %q, align 16
  %id4 = load <16 x float>, ptr %id, align 64
  %t5 = load <16 x float>, ptr %t, align 64
  %136 = extractelement <16 x float> %t5, i32 0
  %137 = extractelement <16 x float> %id4, i32 0
  %138 = fmul float %137, %136
  %139 = fadd float 0.000000e+00, %138
  %140 = extractelement <16 x float> %t5, i32 4
  %141 = extractelement <16 x float> %id4, i32 1
  %142 = fmul float %141, %140
  %143 = fadd float %139, %142
  %144 = extractelement <16 x float> %t5, i32 8
  %145 = extractelement <16 x float> %id4, i32 2
  %146 = fmul float %145, %144
  %147 = fadd float %143, %146
  %148 = extractelement <16 x float> %t5, i32 12
  %149 = extractelement <16 x float> %id4, i32 3
  %150 = fmul float %149, %148
  %151 = fadd float %147, %150
  %152 = insertelement <16 x float> zeroinitializer, float %151, i32 0
  %153 = extractelement <16 x float> %t5, i32 1
  %154 = extractelement <16 x float> %id4, i32 0
  %155 = fmul float %154, %153
  %156 = fadd float 0.000000e+00, %155
  %157 = extractelement <16 x float> %t5, i32 5
  %158 = extractelement <16 x float> %id4, i32 1
  %159 = fmul float %158, %157
  %160 = fadd float %156, %159
  %161 = extractelement <16 x float> %t5, i32 9
  %162 = extractelement <16 x float> %id4, i32 2
  %163 = fmul float %162, %161
  %164 = fadd float %160, %163
  %165 = extractelement <16 x float> %t5, i32 13
  %166 = extractelement <16 x float> %id4, i32 3
  %167 = fmul float %166, %165
  %168 = fadd float %164, %167
  %169 = insertelement <16 x float> %152, float %168, i32 1
  %170 = extractelement <16 x float> %t5, i32 2
  %171 = extractelement <16 x float> %id4, i32 0
  %172 = fmul float %171, %170
  %173 = fadd float 0.000000e+00, %172
  %174 = extractelement <16 x float> %t5, i32 6
  %175 = extractelement <16 x float> %id4, i32 1
  %176 = fmul float %175, %174
  %177 = fadd float %173, %176
  %178 = extractelement <16 x float> %t5, i32 10
  %179 = extractelement <16 x float> %id4, i32 2
  %180 = fmul float %179, %178
  %181 = fadd float %177, %180
  %182 = extractelement <16 x float> %t5, i32 14
  %183 = extractelement <16 x float> %id4, i32 3
  %184 = fmul float %183, %182
  %185 = fadd float %181, %184
  %186 = insertelement <16 x float> %169, float %185, i32 2
  %187 = extractelement <16 x float> %t5, i32 3
  %188 = extractelement <16 x float> %id4, i32 0
  %189 = fmul float %188, %187
  %190 = fadd float 0.000000e+00, %189
  %191 = extractelement <16 x float> %t5, i32 7
  %192 = extractelement <16 x float> %id4, i32 1
  %193 = fmul float %192, %191
  %194 = fadd float %190, %193
  %195 = extractelement <16 x float> %t5, i32 11
  %196 = extractelement <16 x float> %id4, i32 2
  %197 = fmul float %196, %195
  %198 = fadd float %194, %197
  %199 = extractelement <16 x float> %t5, i32 15
  %200 = extractelement <16 x float> %id4, i32 3
  %201 = fmul float %200, %199
  %202 = fadd float %198, %201
  %203 = insertelement <16 x float> %186, float %202, i32 3
  %204 = extractelement <16 x float> %t5, i32 0
  %205 = extractelement <16 x float> %id4, i32 4
  %206 = fmul float %205, %204
  %207 = fadd float 0.000000e+00, %206
  %208 = extractelement <16 x float> %t5, i32 4
  %209 = extractelement <16 x float> %id4, i32 5
  %210 = fmul float %209, %208
  %211 = fadd float %207, %210
  %212 = extractelement <16 x float> %t5, i32 8
  %213 = extractelement <16 x float> %id4, i32 6
  %214 = fmul float %213, %212
  %215 = fadd float %211, %214
  %216 = extractelement <16 x float> %t5, i32 12
  %217 = extractelement <16 x float> %id4, i32 7
  %218 = fmul float %217, %216
  %219 = fadd float %215, %218
  %220 = insertelement <16 x float> %203, float %219, i32 4
  %221 = extractelement <16 x float> %t5, i32 1
  %222 = extractelement <16 x float> %id4, i32 4
  %223 = fmul float %222, %221
  %224 = fadd float 0.000000e+00, %223
  %225 = extractelement <16 x float> %t5, i32 5
  %226 = extractelement <16 x float> %id4, i32 5
  %227 = fmul float %226, %225
  %228 = fadd float %224, %227
  %229 = extractelement <16 x float> %t5, i32 9
  %230 = extractelement <16 x float> %id4, i32 6
  %231 = fmul float %230, %229
  %232 = fadd float %228, %231
  %233 = extractelement <16 x float> %t5, i32 13
  %234 = extractelement <16 x float> %id4, i32 7
  %235 = fmul float %234, %233
  %236 = fadd float %232, %235
  %237 = insertelement <16 x float> %220, float %236, i32 5
  %238 = extractelement <16 x float> %t5, i32 2
  %239 = extractelement <16 x float> %id4, i32 4
  %240 = fmul float %239, %238
  %241 = fadd float 0.000000e+00, %240
  %242 = extractelement <16 x float> %t5, i32 6
  %243 = extractelement <16 x float> %id4, i32 5
  %244 = fmul float %243, %242
  %245 = fadd float %241, %244
  %246 = extractelement <16 x float> %t5, i32 10
  %247 = extractelement <16 x float> %id4, i32 6
  %248 = fmul float %247, %246
  %249 = fadd float %245, %248
  %250 = extractelement <16 x float> %t5, i32 14
  %251 = extractelement <16 x float> %id4, i32 7
  %252 = fmul float %251, %250
  %253 = fadd float %249, %252
  %254 = insertelement <16 x float> %237, float %253, i32 6
  %255 = extractelement <16 x float> %t5, i32 3
  %256 = extractelement <16 x float> %id4, i32 4
  %257 = fmul float %256, %255
  %258 = fadd float 0.000000e+00, %257
  %259 = extractelement <16 x float> %t5, i32 7
  %260 = extractelement <16 x float> %id4, i32 5
  %261 = fmul float %260, %259
  %262 = fadd float %258, %261
  %263 = extractelement <16 x float> %t5, i32 11
  %264 = extractelement <16 x float> %id4, i32 6
  %265 = fmul float %264, %263
  %266 = fadd float %262, %265
  %267 = extractelement <16 x float> %t5, i32 15
  %268 = extractelement <16 x float> %id4, i32 7
  %269 = fmul float %268, %267
  %270 = fadd float %266, %269
  %271 = insertelement <16 x float> %254, float %270, i32 7
  %272 = extractelement <16 x float> %t5, i32 0
  %273 = extractelement <16 x float> %id4, i32 8
  %274 = fmul float %273, %272
  %275 = fadd float 0.000000e+00, %274
  %276 = extractelement <16 x float> %t5, i32 4
  %277 = extractelement <16 x float> %id4, i32 9
  %278 = fmul float %277, %276
  %279 = fadd float %275, %278
  %280 = extractelement <16 x float> %t5, i32 8
  %281 = extractelement <16 x float> %id4, i32 10
  %282 = fmul float %281, %280
  %283 = fadd float %279, %282
  %284 = extractelement <16 x float> %t5, i32 12
  %285 = extractelement <16 x float> %id4, i32 11
  %286 = fmul float %285, %284
  %287 = fadd float %283, %286
  %288 = insertelement <16 x float> %271, float %287, i32 8
  %289 = extractelement <16 x float> %t5, i32 1
  %290 = extractelement <16 x float> %id4, i32 8
  %291 = fmul float %290, %289
  %292 = fadd float 0.000000e+00, %291
  %293 = extractelement <16 x float> %t5, i32 5
  %294 = extractelement <16 x float> %id4, i32 9
  %295 = fmul float %294, %293
  %296 = fadd float %292, %295
  %297 = extractelement <16 x float> %t5, i32 9
  %298 = extractelement <16 x float> %id4, i32 10
  %299 = fmul float %298, %297
  %300 = fadd float %296, %299
  %301 = extractelement <16 x float> %t5, i32 13
  %302 = extractelement <16 x float> %id4, i32 11
  %303 = fmul float %302, %301
  %304 = fadd float %300, %303
  %305 = insertelement <16 x float> %288, float %304, i32 9
  %306 = extractelement <16 x float> %t5, i32 2
  %307 = extractelement <16 x float> %id4, i32 8
  %308 = fmul float %307, %306
  %309 = fadd float 0.000000e+00, %308
  %310 = extractelement <16 x float> %t5, i32 6
  %311 = extractelement <16 x float> %id4, i32 9
  %312 = fmul float %311, %310
  %313 = fadd float %309, %312
  %314 = extractelement <16 x float> %t5, i32 10
  %315 = extractelement <16 x float> %id4, i32 10
  %316 = fmul float %315, %314
  %317 = fadd float %313, %316
  %318 = extractelement <16 x float> %t5, i32 14
  %319 = extractelement <16 x float> %id4, i32 11
  %320 = fmul float %319, %318
  %321 = fadd float %317, %320
  %322 = insertelement <16 x float> %305, float %321, i32 10
  %323 = extractelement <16 x float> %t5, i32 3
  %324 = extractelement <16 x float> %id4, i32 8
  %325 = fmul float %324, %323
  %326 = fadd float 0.000000e+00, %325
  %327 = extractelement <16 x float> %t5, i32 7
  %328 = extractelement <16 x float> %id4, i32 9
  %329 = fmul float %328, %327
  %330 = fadd float %326, %329
  %331 = extractelement <16 x float> %t5, i32 11
  %332 = extractelement <16 x float> %id4, i32 10
  %333 = fmul float %332, %331
  %334 = fadd float %330, %333
  %335 = extractelement <16 x float> %t5, i32 15
  %336 = extractelement <16 x float> %id4, i32 11
  %337 = fmul float %336, %335
  %338 = fadd float %334, %337
  %339 = insertelement <16 x float> %322, float %338, i32 11
  %340 = extractelement <16 x float> %t5, i32 0
  %341 = extractelement <16 x float> %id4, i32 12
  %342 = fmul float %341, %340
  %343 = fadd float 0.000000e+00, %342
  %344 = extractelement <16 x float> %t5, i32 4
  %345 = extractelement <16 x float> %id4, i32 13
  %346 = fmul float %345, %344
  %347 = fadd float %343, %346
  %348 = extractelement <16 x float> %t5, i32 8
  %349 = extractelement <16 x float> %id4, i32 14
  %350 = fmul float %349, %348
  %351 = fadd float %347, %350
  %352 = extractelement <16 x float> %t5, i32 12
  %353 = extractelement <16 x float> %id4, i32 15
  %354 = fmul float %353, %352
  %355 = fadd float %351, %354
  %356 = insertelement <16 x float> %339, float %355, i32 12
  %357 = extractelement <16 x float> %t5, i32 1
  %358 = extractelement <16 x float> %id4, i32 12
  %359 = fmul float %358, %357
  %360 = fadd float 0.000000e+00, %359
  %361 = extractelement <16 x float> %t5, i32 5
  %362 = extractelement <16 x float> %id4, i32 13
  %363 = fmul float %362, %361
  %364 = fadd float %360, %363
  %365 = extractelement <16 x float> %t5, i32 9
  %366 = extractelement <16 x float> %id4, i32 14
  %367 = fmul float %366, %365
  %368 = fadd float %364, %367
  %369 = extractelement <16 x float> %t5, i32 13
  %370 = extractelement <16 x float> %id4, i32 15
  %371 = fmul float %370, %369
  %372 = fadd float %368, %371
  %373 = insertelement <16 x float> %356, float %372, i32 13
  %374 = extractelement <16 x float> %t5, i32 2
  %375 = extractelement <16 x float> %id4, i32 12
  %376 = fmul float %375, %374
  %377 = fadd float 0.000000e+00, %376
  %378 = extractelement <16 x float> %t5, i32 6
  %379 = extractelement <16 x float> %id4, i32 13
  %380 = fmul float %379, %378
  %381 = fadd float %377, %380
  %382 = extractelement <16 x float> %t5, i32 10
  %383 = extractelement <16 x float> %id4, i32 14
  %384 = fmul float %383, %382
  %385 = fadd float %381, %384
  %386 = extractelement <16 x float> %t5, i32 14
  %387 = extractelement <16 x float> %id4, i32 15
  %388 = fmul float %387, %386
  %389 = fadd float %385, %388
  %390 = insertelement <16 x float> %373, float %389, i32 14
  %391 = extractelement <16 x float> %t5, i32 3
  %392 = extractelement <16 x float> %id4, i32 12
  %393 = fmul float %392, %391
  %394 = fadd float 0.000000e+00, %393
  %395 = extractelement <16 x float> %t5, i32 7
  %396 = extractelement <16 x float> %id4, i32 13
  %397 = fmul float %396, %395
  %398 = fadd float %394, %397
  %399 = extractelement <16 x float> %t5, i32 11
  %400 = extractelement <16 x float> %id4, i32 14
  %401 = fmul float %400, %399
  %402 = fadd float %398, %401
  %403 = extractelement <16 x float> %t5, i32 15
  %404 = extractelement <16 x float> %id4, i32 15
  %405 = fmul float %404, %403
  %406 = fadd float %402, %405
  %407 = insertelement <16 x float> %390, float %406, i32 15
  store <16 x float> %407, ptr %m2, align 64
  %tp6 = load <4 x float>, ptr %tp, align 16
  %x = extractelement <4 x float> %tp6, i32 0
  %408 = call i32 @llvm.fptosi.sat.i32.f32(float %x)
  %tp7 = load <4 x float>, ptr %tp, align 16
  %y = extractelement <4 x float> %tp7, i32 1
  %409 = call i32 @llvm.fptosi.sat.i32.f32(float %y)
  %tp8 = load <4 x float>, ptr %tp, align 16
  %z = extractelement <4 x float> %tp8, i32 2
  %410 = call i32 @llvm.fptosi.sat.i32.f32(float %z)
  %q9 = load <4 x float>, ptr %q, align 16
  %x10 = extractelement <4 x float> %q9, i32 0
  %411 = call i32 @llvm.fptosi.sat.i32.f32(float %x10)
  %q11 = load <4 x float>, ptr %q, align 16
  %y12 = extractelement <4 x float> %q11, i32 1
  %412 = call i32 @llvm.fptosi.sat.i32.f32(float %y12)
  %q13 = load <4 x float>, ptr %q, align 16
  %z14 = extractelement <4 x float> %q13, i32 2
  %413 = call i32 @llvm.fptosi.sat.i32.f32(float %z14)
  %m215 = load <16 x float>, ptr %m2, align 64
  br i1 false, label %vidx.bad, label %vidx.ok, !prof !0

vidx.bad:                                         ; preds = %argv.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

vidx.ok:                                          ; preds = %argv.end
  %vec.elem = extractelement <16 x float> %m215, i32 3
  %414 = call i32 @llvm.fptosi.sat.i32.f32(float %vec.elem)
  %415 = call i32 (ptr, ...) @printf(ptr @.str, i32 %408, i32 %409, i32 %410, i32 %411, i32 %412, i32 %413, i32 %414)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5307)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f32(float) #0

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #1

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!"branch_weights", i32 1, i32 1048576}
