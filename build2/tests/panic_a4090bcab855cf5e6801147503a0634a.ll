; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/memory_buffer_overrun.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/memory_buffer_overrun.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Buffer = type { ptr, i64, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Buffer.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @Buffer.length, ptr @Buffer.start, ptr @Buffer.readByte, ptr @Buffer.writeByte, ptr @Buffer.readInt, ptr @Buffer.writeInt, ptr @Buffer.readLong, ptr @Buffer.writeLong, ptr @Buffer.readFloat, ptr @Buffer.writeFloat, ptr @Buffer.readDouble, ptr @Buffer.writeDouble, ptr @Buffer.copyFrom, ptr @"Buffer.read$T", ptr @"Buffer.read$byte", ptr @"Buffer.read$double", ptr @"Buffer.read$float", ptr @"Buffer.read$int", ptr @"Buffer.read$long", ptr @"Buffer.write$T", ptr @"Buffer.write$byte", ptr @"Buffer.write$double", ptr @"Buffer.write$float", ptr @"Buffer.write$int", ptr @"Buffer.write$long", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Buffer.~Buffer"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [18 x i8] c"unreachable = %d\0A\00", align 1
@.contract.1310 = private unnamed_addr constant [94 x i8] c"contract violated: requires\0A  --> <prelude>:90:32  in Buffer.Buffer\0A   |  requires bytes > 0\0A\00", align 1
@.cl.1311 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1312 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1313 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:126:33  in Buffer.readByte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1314 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1315 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1316 = private unnamed_addr constant [111 x i8] c"contract violated: requires\0A  --> <prelude>:127:37  in Buffer.readByte\0A   |  requires offset + 1 <= this.size\0A\00", align 1
@.cl.1317 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1318 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1319 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:133:33  in Buffer.writeByte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1320 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1321 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1322 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:134:37  in Buffer.writeByte\0A   |  requires offset + 1 <= this.size\0A\00", align 1
@.cl.1323 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1324 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1325 = private unnamed_addr constant [98 x i8] c"contract violated: requires\0A  --> <prelude>:141:33  in Buffer.readInt\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1326 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1327 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1328 = private unnamed_addr constant [110 x i8] c"contract violated: requires\0A  --> <prelude>:142:37  in Buffer.readInt\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1329 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1330 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1331 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:148:33  in Buffer.writeInt\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1332 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1333 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1334 = private unnamed_addr constant [111 x i8] c"contract violated: requires\0A  --> <prelude>:149:37  in Buffer.writeInt\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1335 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1336 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1337 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:156:33  in Buffer.readLong\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1338 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1339 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1340 = private unnamed_addr constant [111 x i8] c"contract violated: requires\0A  --> <prelude>:157:37  in Buffer.readLong\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1341 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1342 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1343 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:163:33  in Buffer.writeLong\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1344 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1345 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1346 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:164:37  in Buffer.writeLong\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1347 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1348 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1349 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:171:33  in Buffer.readFloat\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1350 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1351 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1352 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:172:37  in Buffer.readFloat\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1353 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1354 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1355 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:178:33  in Buffer.writeFloat\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1356 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1357 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1358 = private unnamed_addr constant [113 x i8] c"contract violated: requires\0A  --> <prelude>:179:37  in Buffer.writeFloat\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1359 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1360 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1361 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:186:33  in Buffer.readDouble\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1362 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1363 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1364 = private unnamed_addr constant [113 x i8] c"contract violated: requires\0A  --> <prelude>:187:37  in Buffer.readDouble\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1365 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1366 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1367 = private unnamed_addr constant [102 x i8] c"contract violated: requires\0A  --> <prelude>:193:33  in Buffer.writeDouble\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1368 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1369 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1370 = private unnamed_addr constant [114 x i8] c"contract violated: requires\0A  --> <prelude>:194:37  in Buffer.writeDouble\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1371 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1372 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1373 = private unnamed_addr constant [98 x i8] c"contract violated: requires\0A  --> <prelude>:203:32  in Buffer.copyFrom\0A   |  requires bytes >= 0\0A\00", align 1
@.cl.1374 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1375 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1376 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:204:33  in Buffer.copyFrom\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1377 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1378 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1379 = private unnamed_addr constant [115 x i8] c"contract violated: requires\0A  --> <prelude>:205:41  in Buffer.copyFrom\0A   |  requires offset + bytes <= this.size\0A\00", align 1
@.cl.1380 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1381 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1382 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:206:32  in Buffer.copyFrom\0A   |  requires bytes <= source.length()\0A\00", align 1
@.contract.1383 = private unnamed_addr constant [97 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$T\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1384 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1385 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1386 = private unnamed_addr constant [104 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$T\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1387 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1388 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1389 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$byte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1390 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1391 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1392 = private unnamed_addr constant [107 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$byte\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1393 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1394 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1395 = private unnamed_addr constant [102 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$double\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1396 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1397 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1398 = private unnamed_addr constant [109 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$double\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1399 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1400 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1401 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$float\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1402 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1403 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1404 = private unnamed_addr constant [108 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$float\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1405 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1406 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1407 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$int\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1408 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1409 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1410 = private unnamed_addr constant [106 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$int\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1411 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1412 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1413 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$long\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1414 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1415 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1416 = private unnamed_addr constant [107 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$long\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1417 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1418 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1419 = private unnamed_addr constant [98 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$T\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1420 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1421 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1422 = private unnamed_addr constant [105 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$T\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1423 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1424 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1425 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$byte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1426 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1427 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1428 = private unnamed_addr constant [108 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$byte\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1429 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1430 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1431 = private unnamed_addr constant [103 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$double\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1432 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1433 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1434 = private unnamed_addr constant [110 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$double\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1435 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1436 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1437 = private unnamed_addr constant [102 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$float\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1438 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1439 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1440 = private unnamed_addr constant [109 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$float\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1441 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1442 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1443 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$int\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1444 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1445 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1446 = private unnamed_addr constant [107 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$int\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1447 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1448 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1449 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$long\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1450 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1451 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1452 = private unnamed_addr constant [108 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$long\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1453 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1454 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %b = alloca ptr, align 8
  store ptr null, ptr %b, align 8
  %Buffer.obj = alloca %class.Buffer, align 8
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
  call void @Buffer.Buffer(ptr %Buffer.obj, i32 32)
  store ptr %Buffer.obj, ptr %b, align 8
  %b1 = load ptr, ptr %b, align 8
  invoke void @Buffer.writeInt(ptr %b1, i32 30, i32 1)
          to label %invoke.cont unwind label %cleanup.Buffer

cleanup.Buffer:                                   ; preds = %argv.end
  %16 = cleanuppad within none []
  %17 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %17) [ "funclet"(token %16) ]
  cleanupret from %16 unwind to caller

invoke.cont:                                      ; preds = %argv.end
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 1)
  %19 = load ptr, ptr %b, align 8
  %20 = icmp ne ptr %19, null
  br i1 %20, label %dtor.live, label %dtor.done

dtor.live:                                        ; preds = %invoke.cont
  call void @"Buffer.~Buffer"(ptr %19)
  br label %dtor.done

dtor.done:                                        ; preds = %dtor.live, %invoke.cont
  ret i32 0
}

define internal i32 @Object.equals(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @Object.hashCode(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 0
}

define internal i32 @Object.equalsKey(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal void @Object.Object(ptr %0) {
entry:
  %vtbl.addr = getelementptr inbounds %class.Object, ptr %0, i32 0, i32 0
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Buffer.Buffer(ptr %0, i32 %1) {
entry:
  %bytes = alloca i32, align 4
  store i32 %1, ptr %bytes, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 0
  store ptr @Buffer.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %bytes1 = load i32, ptr %bytes, align 4
  %2 = icmp sgt i32 %bytes1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %bytes2 = load i32, ptr %bytes, align 4
  %contract.l = sext i32 %bytes2 to i64
  call void @__polaron_fail(ptr @.contract.1310, ptr @.cl.1311, i64 %contract.l, ptr @.cr.1312, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %bytes3 = load i32, ptr %bytes, align 4
  %4 = zext i32 %bytes3 to i64
  %mem.alloc = call ptr @__polaron_malloc(i64 %4)
  %5 = ptrtoint ptr %mem.alloc to i64
  store i64 %5, ptr %at, align 8, !tbaa !4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %bytes4 = load i32, ptr %bytes, align 4
  store i32 %bytes4, ptr %size, align 4, !tbaa !6
  ret void
}

define internal i32 @Buffer.length(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size1 = load i32, ptr %size, align 4, !tbaa !6
  ret i32 %size1
}

define internal i64 @Buffer.start(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at1 = load i64, ptr %at, align 8, !tbaa !4
  ret i64 %at1
}

define internal i8 @Buffer.readByte(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1313, ptr @.cl.1314, i64 %contract.l, ptr @.cr.1315, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %4 = add i32 %offset3, 1
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp sle i32 %4, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %7 = add i32 %offset8, 1
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %7 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1316, ptr @.cl.1317, i64 %contract.l11, ptr @.cr.1318, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %8 = sext i32 %offset13 to i64
  %9 = add i64 %at12, %8
  %10 = inttoptr i64 %9 to ptr
  %mem.read = load i8, ptr %10, align 1
  ret i8 %mem.read
}

define internal void @Buffer.writeByte(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i8 %2) {
entry:
  %value = alloca i8, align 1
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store i8 %2, ptr %value, align 1
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1319, ptr @.cl.1320, i64 %contract.l, ptr @.cr.1321, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %5 = add i32 %offset3, 1
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %6 = icmp sle i32 %5, %size4
  %7 = zext i1 %6 to i32
  %contract.ok5 = icmp ne i32 %7, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %8 = add i32 %offset8, 1
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1322, ptr @.cl.1323, i64 %contract.l11, ptr @.cr.1324, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %9 = sext i32 %offset13 to i64
  %10 = add i64 %at12, %9
  %value14 = load i8, ptr %value, align 1
  %11 = inttoptr i64 %10 to ptr
  store i8 %value14, ptr %11, align 1
  ret void
}

define internal i32 @Buffer.readInt(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1325, ptr @.cl.1326, i64 %contract.l, ptr @.cr.1327, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %4 = add i32 %offset3, 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp sle i32 %4, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %7 = add i32 %offset8, 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %7 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1328, ptr @.cl.1329, i64 %contract.l11, ptr @.cr.1330, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %8 = sext i32 %offset13 to i64
  %9 = add i64 %at12, %8
  %10 = inttoptr i64 %9 to ptr
  %mem.read = load i32, ptr %10, align 4
  ret i32 %mem.read
}

define internal void @Buffer.writeInt(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store i32 %2, ptr %value, align 4
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1331, ptr @.cl.1332, i64 %contract.l, ptr @.cr.1333, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %5 = add i32 %offset3, 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %6 = icmp sle i32 %5, %size4
  %7 = zext i1 %6 to i32
  %contract.ok5 = icmp ne i32 %7, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %8 = add i32 %offset8, 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1334, ptr @.cl.1335, i64 %contract.l11, ptr @.cr.1336, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %9 = sext i32 %offset13 to i64
  %10 = add i64 %at12, %9
  %value14 = load i32, ptr %value, align 4
  %11 = inttoptr i64 %10 to ptr
  store i32 %value14, ptr %11, align 4
  ret void
}

define internal i64 @Buffer.readLong(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1337, ptr @.cl.1338, i64 %contract.l, ptr @.cr.1339, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %4 = add i32 %offset3, 8
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp sle i32 %4, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %7 = add i32 %offset8, 8
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %7 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1340, ptr @.cl.1341, i64 %contract.l11, ptr @.cr.1342, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %8 = sext i32 %offset13 to i64
  %9 = add i64 %at12, %8
  %10 = inttoptr i64 %9 to ptr
  %mem.read = load i64, ptr %10, align 8
  ret i64 %mem.read
}

define internal void @Buffer.writeLong(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i64 %2) {
entry:
  %value = alloca i64, align 8
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store i64 %2, ptr %value, align 8
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1343, ptr @.cl.1344, i64 %contract.l, ptr @.cr.1345, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %5 = add i32 %offset3, 8
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %6 = icmp sle i32 %5, %size4
  %7 = zext i1 %6 to i32
  %contract.ok5 = icmp ne i32 %7, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %8 = add i32 %offset8, 8
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1346, ptr @.cl.1347, i64 %contract.l11, ptr @.cr.1348, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %9 = sext i32 %offset13 to i64
  %10 = add i64 %at12, %9
  %value14 = load i64, ptr %value, align 8
  %11 = inttoptr i64 %10 to ptr
  store i64 %value14, ptr %11, align 8
  ret void
}

define internal float @Buffer.readFloat(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1349, ptr @.cl.1350, i64 %contract.l, ptr @.cr.1351, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %4 = add i32 %offset3, 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp sle i32 %4, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %7 = add i32 %offset8, 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %7 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1352, ptr @.cl.1353, i64 %contract.l11, ptr @.cr.1354, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %8 = sext i32 %offset13 to i64
  %9 = add i64 %at12, %8
  %10 = inttoptr i64 %9 to ptr
  %mem.read = load float, ptr %10, align 4
  ret float %mem.read
}

define internal void @Buffer.writeFloat(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, float %2) {
entry:
  %value = alloca float, align 4
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store float %2, ptr %value, align 4
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1355, ptr @.cl.1356, i64 %contract.l, ptr @.cr.1357, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %5 = add i32 %offset3, 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %6 = icmp sle i32 %5, %size4
  %7 = zext i1 %6 to i32
  %contract.ok5 = icmp ne i32 %7, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %8 = add i32 %offset8, 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1358, ptr @.cl.1359, i64 %contract.l11, ptr @.cr.1360, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %9 = sext i32 %offset13 to i64
  %10 = add i64 %at12, %9
  %value14 = load float, ptr %value, align 4
  %11 = inttoptr i64 %10 to ptr
  store float %value14, ptr %11, align 4
  ret void
}

define internal double @Buffer.readDouble(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1361, ptr @.cl.1362, i64 %contract.l, ptr @.cr.1363, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %4 = add i32 %offset3, 8
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp sle i32 %4, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %7 = add i32 %offset8, 8
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %7 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1364, ptr @.cl.1365, i64 %contract.l11, ptr @.cr.1366, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %8 = sext i32 %offset13 to i64
  %9 = add i64 %at12, %8
  %10 = inttoptr i64 %9 to ptr
  %mem.read = load double, ptr %10, align 8
  ret double %mem.read
}

define internal void @Buffer.writeDouble(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, double %2) {
entry:
  %value = alloca double, align 8
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store double %2, ptr %value, align 8
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1367, ptr @.cl.1368, i64 %contract.l, ptr @.cr.1369, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %5 = add i32 %offset3, 8
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %6 = icmp sle i32 %5, %size4
  %7 = zext i1 %6 to i32
  %contract.ok5 = icmp ne i32 %7, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %8 = add i32 %offset8, 8
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1370, ptr @.cl.1371, i64 %contract.l11, ptr @.cr.1372, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %9 = sext i32 %offset13 to i64
  %10 = add i64 %at12, %9
  %value14 = load double, ptr %value, align 8
  %11 = inttoptr i64 %10 to ptr
  store double %value14, ptr %11, align 8
  ret void
}

define internal void @Buffer.copyFrom(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3) {
entry:
  %bytes = alloca i32, align 4
  %offset = alloca i32, align 4
  %source = alloca ptr, align 8
  store ptr %1, ptr %source, align 8
  store i32 %2, ptr %offset, align 4
  store i32 %3, ptr %bytes, align 4
  %bytes1 = load i32, ptr %bytes, align 4
  %4 = icmp sge i32 %bytes1, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %bytes2 = load i32, ptr %bytes, align 4
  %contract.l = sext i32 %bytes2 to i64
  call void @__polaron_fail(ptr @.contract.1373, ptr @.cl.1374, i64 %contract.l, ptr @.cr.1375, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %6 = icmp sge i32 %offset3, 0
  %7 = zext i1 %6 to i32
  %contract.ok4 = icmp ne i32 %7, 0
  br i1 %contract.ok4, label %contract.cont6, label %contract.fail5

contract.fail5:                                   ; preds = %contract.cont
  %offset7 = load i32, ptr %offset, align 4
  %contract.l8 = sext i32 %offset7 to i64
  call void @__polaron_fail(ptr @.contract.1376, ptr @.cl.1377, i64 %contract.l8, ptr @.cr.1378, i64 0, i32 1)
  unreachable

contract.cont6:                                   ; preds = %contract.cont
  %offset9 = load i32, ptr %offset, align 4
  %bytes10 = load i32, ptr %bytes, align 4
  %8 = add i32 %offset9, %bytes10
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size11 = load i32, ptr %size, align 4, !tbaa !6
  %9 = icmp sle i32 %8, %size11
  %10 = zext i1 %9 to i32
  %contract.ok12 = icmp ne i32 %10, 0
  br i1 %contract.ok12, label %contract.cont14, label %contract.fail13

contract.fail13:                                  ; preds = %contract.cont6
  %offset15 = load i32, ptr %offset, align 4
  %bytes16 = load i32, ptr %bytes, align 4
  %11 = add i32 %offset15, %bytes16
  %size17 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size18 = load i32, ptr %size17, align 4, !tbaa !6
  %contract.l19 = sext i32 %11 to i64
  %contract.r = sext i32 %size18 to i64
  call void @__polaron_fail(ptr @.contract.1379, ptr @.cl.1380, i64 %contract.l19, ptr @.cr.1381, i64 %contract.r, i32 1)
  unreachable

contract.cont14:                                  ; preds = %contract.cont6
  %bytes20 = load i32, ptr %bytes, align 4
  %source21 = load ptr, ptr %source, align 8
  %12 = call i32 @Buffer.length(ptr %source21)
  %13 = icmp sle i32 %bytes20, %12
  %14 = zext i1 %13 to i32
  %contract.ok22 = icmp ne i32 %14, 0
  br i1 %contract.ok22, label %contract.cont24, label %contract.fail23

contract.fail23:                                  ; preds = %contract.cont14
  call void @__polaron_fail(ptr @.contract.1382, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont24:                                  ; preds = %contract.cont14
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at25 = load i64, ptr %at, align 8, !tbaa !4
  %offset26 = load i32, ptr %offset, align 4
  %15 = sext i32 %offset26 to i64
  %16 = add i64 %at25, %15
  %source27 = load ptr, ptr %source, align 8
  %17 = call i64 @Buffer.start(ptr %source27)
  %bytes28 = load i32, ptr %bytes, align 4
  %18 = sext i32 %bytes28 to i64
  %19 = inttoptr i64 %17 to ptr
  %20 = inttoptr i64 %16 to ptr
  %21 = call ptr @memcpy(ptr %20, ptr %19, i64 %18)
  ret void
}

define internal void @"Buffer.~Buffer"(ptr %0) {
entry:
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at1 = load i64, ptr %at, align 8, !tbaa !4
  %1 = icmp ne i64 %at1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %at2 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at3 = load i64, ptr %at2, align 8, !tbaa !4
  %3 = inttoptr i64 %at3 to ptr
  call void @__polaron_free(ptr %3)
  %at4 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  store i64 0, ptr %at4, align 8, !tbaa !4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal i32 @"Buffer.read$T"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1383, ptr @.cl.1384, i64 %contract.l, ptr @.cr.1385, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %4 = icmp slt i32 %offset3, %size4
  %5 = zext i1 %4 to i32
  %contract.ok5 = icmp ne i32 %5, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1386, ptr @.cl.1387, i64 %contract.l11, ptr @.cr.1388, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %6 = sext i32 %offset13 to i64
  %7 = add i64 %at12, %6
  %8 = inttoptr i64 %7 to ptr
  %mem.read = load i32, ptr %8, align 4
  ret i32 %mem.read
}

define internal i8 @"Buffer.read$byte"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1389, ptr @.cl.1390, i64 %contract.l, ptr @.cr.1391, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %4 = icmp slt i32 %offset3, %size4
  %5 = zext i1 %4 to i32
  %contract.ok5 = icmp ne i32 %5, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1392, ptr @.cl.1393, i64 %contract.l11, ptr @.cr.1394, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %6 = sext i32 %offset13 to i64
  %7 = add i64 %at12, %6
  %8 = inttoptr i64 %7 to ptr
  %mem.read = load i8, ptr %8, align 1
  ret i8 %mem.read
}

define internal double @"Buffer.read$double"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1395, ptr @.cl.1396, i64 %contract.l, ptr @.cr.1397, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %4 = icmp slt i32 %offset3, %size4
  %5 = zext i1 %4 to i32
  %contract.ok5 = icmp ne i32 %5, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1398, ptr @.cl.1399, i64 %contract.l11, ptr @.cr.1400, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %6 = sext i32 %offset13 to i64
  %7 = add i64 %at12, %6
  %8 = inttoptr i64 %7 to ptr
  %mem.read = load double, ptr %8, align 8
  ret double %mem.read
}

define internal float @"Buffer.read$float"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1401, ptr @.cl.1402, i64 %contract.l, ptr @.cr.1403, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %4 = icmp slt i32 %offset3, %size4
  %5 = zext i1 %4 to i32
  %contract.ok5 = icmp ne i32 %5, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1404, ptr @.cl.1405, i64 %contract.l11, ptr @.cr.1406, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %6 = sext i32 %offset13 to i64
  %7 = add i64 %at12, %6
  %8 = inttoptr i64 %7 to ptr
  %mem.read = load float, ptr %8, align 4
  ret float %mem.read
}

define internal i32 @"Buffer.read$int"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1407, ptr @.cl.1408, i64 %contract.l, ptr @.cr.1409, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %4 = icmp slt i32 %offset3, %size4
  %5 = zext i1 %4 to i32
  %contract.ok5 = icmp ne i32 %5, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1410, ptr @.cl.1411, i64 %contract.l11, ptr @.cr.1412, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %6 = sext i32 %offset13 to i64
  %7 = add i64 %at12, %6
  %8 = inttoptr i64 %7 to ptr
  %mem.read = load i32, ptr %8, align 4
  ret i32 %mem.read
}

define internal i64 @"Buffer.read$long"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  %offset1 = load i32, ptr %offset, align 4
  %2 = icmp sge i32 %offset1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1413, ptr @.cl.1414, i64 %contract.l, ptr @.cr.1415, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %4 = icmp slt i32 %offset3, %size4
  %5 = zext i1 %4 to i32
  %contract.ok5 = icmp ne i32 %5, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1416, ptr @.cl.1417, i64 %contract.l11, ptr @.cr.1418, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %6 = sext i32 %offset13 to i64
  %7 = add i64 %at12, %6
  %8 = inttoptr i64 %7 to ptr
  %mem.read = load i64, ptr %8, align 8
  ret i64 %mem.read
}

define internal void @"Buffer.write$T"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store i32 %2, ptr %value, align 4
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1419, ptr @.cl.1420, i64 %contract.l, ptr @.cr.1421, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp slt i32 %offset3, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1422, ptr @.cl.1423, i64 %contract.l11, ptr @.cr.1424, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %7 = sext i32 %offset13 to i64
  %8 = add i64 %at12, %7
  %value14 = load i32, ptr %value, align 4
  %9 = inttoptr i64 %8 to ptr
  store i32 %value14, ptr %9, align 4
  ret void
}

define internal void @"Buffer.write$byte"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i8 %2) {
entry:
  %value = alloca i8, align 1
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store i8 %2, ptr %value, align 1
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1425, ptr @.cl.1426, i64 %contract.l, ptr @.cr.1427, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp slt i32 %offset3, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1428, ptr @.cl.1429, i64 %contract.l11, ptr @.cr.1430, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %7 = sext i32 %offset13 to i64
  %8 = add i64 %at12, %7
  %value14 = load i8, ptr %value, align 1
  %9 = inttoptr i64 %8 to ptr
  store i8 %value14, ptr %9, align 1
  ret void
}

define internal void @"Buffer.write$double"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, double %2) {
entry:
  %value = alloca double, align 8
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store double %2, ptr %value, align 8
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1431, ptr @.cl.1432, i64 %contract.l, ptr @.cr.1433, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp slt i32 %offset3, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1434, ptr @.cl.1435, i64 %contract.l11, ptr @.cr.1436, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %7 = sext i32 %offset13 to i64
  %8 = add i64 %at12, %7
  %value14 = load double, ptr %value, align 8
  %9 = inttoptr i64 %8 to ptr
  store double %value14, ptr %9, align 8
  ret void
}

define internal void @"Buffer.write$float"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, float %2) {
entry:
  %value = alloca float, align 4
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store float %2, ptr %value, align 4
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1437, ptr @.cl.1438, i64 %contract.l, ptr @.cr.1439, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp slt i32 %offset3, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1440, ptr @.cl.1441, i64 %contract.l11, ptr @.cr.1442, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %7 = sext i32 %offset13 to i64
  %8 = add i64 %at12, %7
  %value14 = load float, ptr %value, align 4
  %9 = inttoptr i64 %8 to ptr
  store float %value14, ptr %9, align 4
  ret void
}

define internal void @"Buffer.write$int"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store i32 %2, ptr %value, align 4
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1443, ptr @.cl.1444, i64 %contract.l, ptr @.cr.1445, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp slt i32 %offset3, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1446, ptr @.cl.1447, i64 %contract.l11, ptr @.cr.1448, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %7 = sext i32 %offset13 to i64
  %8 = add i64 %at12, %7
  %value14 = load i32, ptr %value, align 4
  %9 = inttoptr i64 %8 to ptr
  store i32 %value14, ptr %9, align 4
  ret void
}

define internal void @"Buffer.write$long"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i64 %2) {
entry:
  %value = alloca i64, align 8
  %offset = alloca i32, align 4
  store i32 %1, ptr %offset, align 4
  store i64 %2, ptr %value, align 8
  %offset1 = load i32, ptr %offset, align 4
  %3 = icmp sge i32 %offset1, 0
  %4 = zext i1 %3 to i32
  %contract.ok = icmp ne i32 %4, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %offset2 = load i32, ptr %offset, align 4
  %contract.l = sext i32 %offset2 to i64
  call void @__polaron_fail(ptr @.contract.1449, ptr @.cl.1450, i64 %contract.l, ptr @.cr.1451, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %offset3 = load i32, ptr %offset, align 4
  %size = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4, !tbaa !6
  %5 = icmp slt i32 %offset3, %size4
  %6 = zext i1 %5 to i32
  %contract.ok5 = icmp ne i32 %6, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %offset8 = load i32, ptr %offset, align 4
  %size9 = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 2
  %size10 = load i32, ptr %size9, align 4, !tbaa !6
  %contract.l11 = sext i32 %offset8 to i64
  %contract.r = sext i32 %size10 to i64
  call void @__polaron_fail(ptr @.contract.1452, ptr @.cl.1453, i64 %contract.l11, ptr @.cr.1454, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %at = getelementptr inbounds %class.Buffer, ptr %0, i32 0, i32 1
  %at12 = load i64, ptr %at, align 8, !tbaa !4
  %offset13 = load i32, ptr %offset, align 4
  %7 = sext i32 %offset13 to i64
  %8 = add i64 %at12, %7
  %value14 = load i64, ptr %value, align 8
  %9 = inttoptr i64 %8 to ptr
  store i64 %value14, ptr %9, align 8
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @__CxxFrameHandler3(...)

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i64", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i32", !2, i64 0}
