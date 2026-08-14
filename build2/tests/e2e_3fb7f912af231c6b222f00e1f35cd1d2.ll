; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/memory_buffer.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/memory_buffer.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Buffer = type { ptr, i64, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Buffer.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @Buffer.length, ptr @Buffer.start, ptr @Buffer.readByte, ptr @Buffer.writeByte, ptr @Buffer.readInt, ptr @Buffer.writeInt, ptr @Buffer.readLong, ptr @Buffer.writeLong, ptr @Buffer.readFloat, ptr @Buffer.writeFloat, ptr @Buffer.readDouble, ptr @Buffer.writeDouble, ptr @Buffer.copyFrom, ptr @"Buffer.read$T", ptr @"Buffer.read$byte", ptr @"Buffer.read$double", ptr @"Buffer.read$float", ptr @"Buffer.read$int", ptr @"Buffer.read$long", ptr @"Buffer.write$T", ptr @"Buffer.write$byte", ptr @"Buffer.write$double", ptr @"Buffer.write$float", ptr @"Buffer.write$int", ptr @"Buffer.write$long", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Buffer.~Buffer"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [13 x i8] c"length = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"ints = %d %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"byte = %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"long = %lld\0A\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"last = %d\0A\00", align 1
@.str.5 = private unnamed_addr constant [13 x i8] c"copied = %d\0A\00", align 1
@.str.6 = private unnamed_addr constant [14 x i8] c"generic = %d\0A\00", align 1
@.contract.1316 = private unnamed_addr constant [94 x i8] c"contract violated: requires\0A  --> <prelude>:90:32  in Buffer.Buffer\0A   |  requires bytes > 0\0A\00", align 1
@.cl.1317 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1318 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1319 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:126:33  in Buffer.readByte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1320 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1321 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1322 = private unnamed_addr constant [111 x i8] c"contract violated: requires\0A  --> <prelude>:127:37  in Buffer.readByte\0A   |  requires offset + 1 <= this.size\0A\00", align 1
@.cl.1323 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1324 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1325 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:133:33  in Buffer.writeByte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1326 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1327 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1328 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:134:37  in Buffer.writeByte\0A   |  requires offset + 1 <= this.size\0A\00", align 1
@.cl.1329 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1330 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1331 = private unnamed_addr constant [98 x i8] c"contract violated: requires\0A  --> <prelude>:141:33  in Buffer.readInt\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1332 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1333 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1334 = private unnamed_addr constant [110 x i8] c"contract violated: requires\0A  --> <prelude>:142:37  in Buffer.readInt\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1335 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1336 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1337 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:148:33  in Buffer.writeInt\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1338 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1339 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1340 = private unnamed_addr constant [111 x i8] c"contract violated: requires\0A  --> <prelude>:149:37  in Buffer.writeInt\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1341 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1342 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1343 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:156:33  in Buffer.readLong\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1344 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1345 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1346 = private unnamed_addr constant [111 x i8] c"contract violated: requires\0A  --> <prelude>:157:37  in Buffer.readLong\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1347 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1348 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1349 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:163:33  in Buffer.writeLong\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1350 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1351 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1352 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:164:37  in Buffer.writeLong\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1353 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1354 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1355 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:171:33  in Buffer.readFloat\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1356 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1357 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1358 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:172:37  in Buffer.readFloat\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1359 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1360 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1361 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:178:33  in Buffer.writeFloat\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1362 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1363 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1364 = private unnamed_addr constant [113 x i8] c"contract violated: requires\0A  --> <prelude>:179:37  in Buffer.writeFloat\0A   |  requires offset + 4 <= this.size\0A\00", align 1
@.cl.1365 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1366 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1367 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:186:33  in Buffer.readDouble\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1368 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1369 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1370 = private unnamed_addr constant [113 x i8] c"contract violated: requires\0A  --> <prelude>:187:37  in Buffer.readDouble\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1371 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1372 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1373 = private unnamed_addr constant [102 x i8] c"contract violated: requires\0A  --> <prelude>:193:33  in Buffer.writeDouble\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1374 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1375 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1376 = private unnamed_addr constant [114 x i8] c"contract violated: requires\0A  --> <prelude>:194:37  in Buffer.writeDouble\0A   |  requires offset + 8 <= this.size\0A\00", align 1
@.cl.1377 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1378 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1379 = private unnamed_addr constant [98 x i8] c"contract violated: requires\0A  --> <prelude>:203:32  in Buffer.copyFrom\0A   |  requires bytes >= 0\0A\00", align 1
@.cl.1380 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1381 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1382 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:204:33  in Buffer.copyFrom\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1383 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1384 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1385 = private unnamed_addr constant [115 x i8] c"contract violated: requires\0A  --> <prelude>:205:41  in Buffer.copyFrom\0A   |  requires offset + bytes <= this.size\0A\00", align 1
@.cl.1386 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1387 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1388 = private unnamed_addr constant [112 x i8] c"contract violated: requires\0A  --> <prelude>:206:32  in Buffer.copyFrom\0A   |  requires bytes <= source.length()\0A\00", align 1
@.contract.1389 = private unnamed_addr constant [97 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$T\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1390 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1391 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1392 = private unnamed_addr constant [104 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$T\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1393 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1394 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1395 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$byte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1396 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1397 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1398 = private unnamed_addr constant [107 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$byte\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1399 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1400 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1401 = private unnamed_addr constant [102 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$double\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1402 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1403 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1404 = private unnamed_addr constant [109 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$double\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1405 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1406 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1407 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$float\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1408 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1409 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1410 = private unnamed_addr constant [108 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$float\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1411 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1412 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1413 = private unnamed_addr constant [99 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$int\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1414 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1415 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1416 = private unnamed_addr constant [106 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$int\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1417 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1418 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1419 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:111:33  in Buffer.read$long\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1420 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1421 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1422 = private unnamed_addr constant [107 x i8] c"contract violated: requires\0A  --> <prelude>:112:33  in Buffer.read$long\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1423 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1424 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1425 = private unnamed_addr constant [98 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$T\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1426 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1427 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1428 = private unnamed_addr constant [105 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$T\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1429 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1430 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1431 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$byte\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1432 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1433 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1434 = private unnamed_addr constant [108 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$byte\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1435 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1436 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1437 = private unnamed_addr constant [103 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$double\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1438 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1439 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1440 = private unnamed_addr constant [110 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$double\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1441 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1442 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1443 = private unnamed_addr constant [102 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$float\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1444 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1445 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1446 = private unnamed_addr constant [109 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$float\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1447 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1448 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1449 = private unnamed_addr constant [100 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$int\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1450 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1451 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1452 = private unnamed_addr constant [107 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$int\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1453 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1454 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1455 = private unnamed_addr constant [101 x i8] c"contract violated: requires\0A  --> <prelude>:118:33  in Buffer.write$long\0A   |  requires offset >= 0\0A\00", align 1
@.cl.1456 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1457 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1458 = private unnamed_addr constant [108 x i8] c"contract violated: requires\0A  --> <prelude>:119:33  in Buffer.write$long\0A   |  requires offset < this.size\0A\00", align 1
@.cl.1459 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1460 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %src = alloca ptr, align 8
  store ptr null, ptr %src, align 8
  %Buffer.obj32 = alloca %class.Buffer, align 8
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
  %16 = invoke i32 @Buffer.length(ptr %b1)
          to label %invoke.cont unwind label %cleanup.Buffer

cleanup.Buffer:                                   ; preds = %argv.end
  %17 = cleanuppad within none []
  %18 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %18) [ "funclet"(token %17) ]
  cleanupret from %17 unwind to caller

invoke.cont:                                      ; preds = %argv.end
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16)
  %b2 = load ptr, ptr %b, align 8
  invoke void @Buffer.writeInt(ptr %b2, i32 0, i32 7)
          to label %invoke.cont4 unwind label %cleanup.Buffer3

cleanup.Buffer3:                                  ; preds = %invoke.cont
  %20 = cleanuppad within none []
  %21 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %21) [ "funclet"(token %20) ]
  cleanupret from %20 unwind to caller

invoke.cont4:                                     ; preds = %invoke.cont
  %b5 = load ptr, ptr %b, align 8
  invoke void @Buffer.writeInt(ptr %b5, i32 4, i32 11)
          to label %invoke.cont7 unwind label %cleanup.Buffer6

cleanup.Buffer6:                                  ; preds = %invoke.cont4
  %22 = cleanuppad within none []
  %23 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %23) [ "funclet"(token %22) ]
  cleanupret from %22 unwind to caller

invoke.cont7:                                     ; preds = %invoke.cont4
  %b8 = load ptr, ptr %b, align 8
  invoke void @Buffer.writeByte(ptr %b8, i32 8, i8 3)
          to label %invoke.cont10 unwind label %cleanup.Buffer9

cleanup.Buffer9:                                  ; preds = %invoke.cont7
  %24 = cleanuppad within none []
  %25 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %25) [ "funclet"(token %24) ]
  cleanupret from %24 unwind to caller

invoke.cont10:                                    ; preds = %invoke.cont7
  %b11 = load ptr, ptr %b, align 8
  invoke void @Buffer.writeLong(ptr %b11, i32 16, i64 1234567)
          to label %invoke.cont13 unwind label %cleanup.Buffer12

cleanup.Buffer12:                                 ; preds = %invoke.cont10
  %26 = cleanuppad within none []
  %27 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %27) [ "funclet"(token %26) ]
  cleanupret from %26 unwind to caller

invoke.cont13:                                    ; preds = %invoke.cont10
  %b14 = load ptr, ptr %b, align 8
  %28 = invoke i32 @Buffer.readInt(ptr %b14, i32 0)
          to label %invoke.cont16 unwind label %cleanup.Buffer15

cleanup.Buffer15:                                 ; preds = %invoke.cont13
  %29 = cleanuppad within none []
  %30 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %30) [ "funclet"(token %29) ]
  cleanupret from %29 unwind to caller

invoke.cont16:                                    ; preds = %invoke.cont13
  %b17 = load ptr, ptr %b, align 8
  %31 = invoke i32 @Buffer.readInt(ptr %b17, i32 4)
          to label %invoke.cont19 unwind label %cleanup.Buffer18

cleanup.Buffer18:                                 ; preds = %invoke.cont16
  %32 = cleanuppad within none []
  %33 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %33) [ "funclet"(token %32) ]
  cleanupret from %32 unwind to caller

invoke.cont19:                                    ; preds = %invoke.cont16
  %34 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %28, i32 %31)
  %b20 = load ptr, ptr %b, align 8
  %35 = invoke i8 @Buffer.readByte(ptr %b20, i32 8)
          to label %invoke.cont22 unwind label %cleanup.Buffer21

cleanup.Buffer21:                                 ; preds = %invoke.cont19
  %36 = cleanuppad within none []
  %37 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %37) [ "funclet"(token %36) ]
  cleanupret from %36 unwind to caller

invoke.cont22:                                    ; preds = %invoke.cont19
  %38 = sext i8 %35 to i32
  %39 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %38)
  %b23 = load ptr, ptr %b, align 8
  %40 = invoke i64 @Buffer.readLong(ptr %b23, i32 16)
          to label %invoke.cont25 unwind label %cleanup.Buffer24

cleanup.Buffer24:                                 ; preds = %invoke.cont22
  %41 = cleanuppad within none []
  %42 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %42) [ "funclet"(token %41) ]
  cleanupret from %41 unwind to caller

invoke.cont25:                                    ; preds = %invoke.cont22
  %43 = call i32 (ptr, ...) @printf(ptr @.str.3, i64 %40)
  %b26 = load ptr, ptr %b, align 8
  invoke void @Buffer.writeInt(ptr %b26, i32 28, i32 99)
          to label %invoke.cont28 unwind label %cleanup.Buffer27

cleanup.Buffer27:                                 ; preds = %invoke.cont25
  %44 = cleanuppad within none []
  %45 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %45) [ "funclet"(token %44) ]
  cleanupret from %44 unwind to caller

invoke.cont28:                                    ; preds = %invoke.cont25
  %b29 = load ptr, ptr %b, align 8
  %46 = invoke i32 @Buffer.readInt(ptr %b29, i32 28)
          to label %invoke.cont31 unwind label %cleanup.Buffer30

cleanup.Buffer30:                                 ; preds = %invoke.cont28
  %47 = cleanuppad within none []
  %48 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %48) [ "funclet"(token %47) ]
  cleanupret from %47 unwind to caller

invoke.cont31:                                    ; preds = %invoke.cont28
  %49 = call i32 (ptr, ...) @printf(ptr @.str.4, i32 %46)
  invoke void @Buffer.Buffer(ptr %Buffer.obj32, i32 8)
          to label %invoke.cont34 unwind label %cleanup.Buffer33

cleanup.Buffer33:                                 ; preds = %invoke.cont31
  %50 = cleanuppad within none []
  %51 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %51) [ "funclet"(token %50) ]
  cleanupret from %50 unwind to caller

invoke.cont34:                                    ; preds = %invoke.cont31
  store ptr %Buffer.obj32, ptr %src, align 8
  %src35 = load ptr, ptr %src, align 8
  invoke void @Buffer.writeInt(ptr %src35, i32 0, i32 42)
          to label %invoke.cont38 unwind label %cleanup.Buffer37

cleanup.Buffer36:                                 ; preds = %cleanup.Buffer37
  %52 = cleanuppad within none []
  %53 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %53) [ "funclet"(token %52) ]
  cleanupret from %52 unwind to caller

cleanup.Buffer37:                                 ; preds = %invoke.cont34
  %54 = cleanuppad within none []
  %55 = load ptr, ptr %src, align 8
  call void @"Buffer.~Buffer"(ptr %55) [ "funclet"(token %54) ]
  cleanupret from %54 unwind label %cleanup.Buffer36

invoke.cont38:                                    ; preds = %invoke.cont34
  %b39 = load ptr, ptr %b, align 8
  %src40 = load ptr, ptr %src, align 8
  invoke void @Buffer.copyFrom(ptr %b39, ptr %src40, i32 20, i32 4)
          to label %invoke.cont43 unwind label %cleanup.Buffer42

cleanup.Buffer41:                                 ; preds = %cleanup.Buffer42
  %56 = cleanuppad within none []
  %57 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %57) [ "funclet"(token %56) ]
  cleanupret from %56 unwind to caller

cleanup.Buffer42:                                 ; preds = %invoke.cont38
  %58 = cleanuppad within none []
  %59 = load ptr, ptr %src, align 8
  call void @"Buffer.~Buffer"(ptr %59) [ "funclet"(token %58) ]
  cleanupret from %58 unwind label %cleanup.Buffer41

invoke.cont43:                                    ; preds = %invoke.cont38
  %b44 = load ptr, ptr %b, align 8
  %60 = invoke i32 @Buffer.readInt(ptr %b44, i32 20)
          to label %invoke.cont47 unwind label %cleanup.Buffer46

cleanup.Buffer45:                                 ; preds = %cleanup.Buffer46
  %61 = cleanuppad within none []
  %62 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %62) [ "funclet"(token %61) ]
  cleanupret from %61 unwind to caller

cleanup.Buffer46:                                 ; preds = %invoke.cont43
  %63 = cleanuppad within none []
  %64 = load ptr, ptr %src, align 8
  call void @"Buffer.~Buffer"(ptr %64) [ "funclet"(token %63) ]
  cleanupret from %63 unwind label %cleanup.Buffer45

invoke.cont47:                                    ; preds = %invoke.cont43
  %65 = call i32 (ptr, ...) @printf(ptr @.str.5, i32 %60)
  %b48 = load ptr, ptr %b, align 8
  invoke void @"Buffer.write$int"(ptr %b48, i32 24, i32 55)
          to label %invoke.cont51 unwind label %cleanup.Buffer50

cleanup.Buffer49:                                 ; preds = %cleanup.Buffer50
  %66 = cleanuppad within none []
  %67 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %67) [ "funclet"(token %66) ]
  cleanupret from %66 unwind to caller

cleanup.Buffer50:                                 ; preds = %invoke.cont47
  %68 = cleanuppad within none []
  %69 = load ptr, ptr %src, align 8
  call void @"Buffer.~Buffer"(ptr %69) [ "funclet"(token %68) ]
  cleanupret from %68 unwind label %cleanup.Buffer49

invoke.cont51:                                    ; preds = %invoke.cont47
  %b52 = load ptr, ptr %b, align 8
  %70 = invoke i32 @"Buffer.read$int"(ptr %b52, i32 24)
          to label %invoke.cont55 unwind label %cleanup.Buffer54

cleanup.Buffer53:                                 ; preds = %cleanup.Buffer54
  %71 = cleanuppad within none []
  %72 = load ptr, ptr %b, align 8
  call void @"Buffer.~Buffer"(ptr %72) [ "funclet"(token %71) ]
  cleanupret from %71 unwind to caller

cleanup.Buffer54:                                 ; preds = %invoke.cont51
  %73 = cleanuppad within none []
  %74 = load ptr, ptr %src, align 8
  call void @"Buffer.~Buffer"(ptr %74) [ "funclet"(token %73) ]
  cleanupret from %73 unwind label %cleanup.Buffer53

invoke.cont55:                                    ; preds = %invoke.cont51
  %75 = call i32 (ptr, ...) @printf(ptr @.str.6, i32 %70)
  %76 = load ptr, ptr %src, align 8
  %77 = icmp ne ptr %76, null
  br i1 %77, label %dtor.live, label %dtor.done

dtor.live:                                        ; preds = %invoke.cont55
  call void @"Buffer.~Buffer"(ptr %76)
  br label %dtor.done

dtor.done:                                        ; preds = %dtor.live, %invoke.cont55
  %78 = load ptr, ptr %b, align 8
  %79 = icmp ne ptr %78, null
  br i1 %79, label %dtor.live56, label %dtor.done57

dtor.live56:                                      ; preds = %dtor.done
  call void @"Buffer.~Buffer"(ptr %78)
  br label %dtor.done57

dtor.done57:                                      ; preds = %dtor.live56, %dtor.done
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
  call void @__polaron_fail(ptr @.contract.1316, ptr @.cl.1317, i64 %contract.l, ptr @.cr.1318, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1319, ptr @.cl.1320, i64 %contract.l, ptr @.cr.1321, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1322, ptr @.cl.1323, i64 %contract.l11, ptr @.cr.1324, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1325, ptr @.cl.1326, i64 %contract.l, ptr @.cr.1327, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1328, ptr @.cl.1329, i64 %contract.l11, ptr @.cr.1330, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1331, ptr @.cl.1332, i64 %contract.l, ptr @.cr.1333, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1334, ptr @.cl.1335, i64 %contract.l11, ptr @.cr.1336, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1337, ptr @.cl.1338, i64 %contract.l, ptr @.cr.1339, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1340, ptr @.cl.1341, i64 %contract.l11, ptr @.cr.1342, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1343, ptr @.cl.1344, i64 %contract.l, ptr @.cr.1345, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1346, ptr @.cl.1347, i64 %contract.l11, ptr @.cr.1348, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1349, ptr @.cl.1350, i64 %contract.l, ptr @.cr.1351, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1352, ptr @.cl.1353, i64 %contract.l11, ptr @.cr.1354, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1355, ptr @.cl.1356, i64 %contract.l, ptr @.cr.1357, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1358, ptr @.cl.1359, i64 %contract.l11, ptr @.cr.1360, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1361, ptr @.cl.1362, i64 %contract.l, ptr @.cr.1363, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1364, ptr @.cl.1365, i64 %contract.l11, ptr @.cr.1366, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1367, ptr @.cl.1368, i64 %contract.l, ptr @.cr.1369, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1370, ptr @.cl.1371, i64 %contract.l11, ptr @.cr.1372, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1373, ptr @.cl.1374, i64 %contract.l, ptr @.cr.1375, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1376, ptr @.cl.1377, i64 %contract.l11, ptr @.cr.1378, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1379, ptr @.cl.1380, i64 %contract.l, ptr @.cr.1381, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1382, ptr @.cl.1383, i64 %contract.l8, ptr @.cr.1384, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1385, ptr @.cl.1386, i64 %contract.l19, ptr @.cr.1387, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1388, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1419, ptr @.cl.1420, i64 %contract.l, ptr @.cr.1421, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1422, ptr @.cl.1423, i64 %contract.l11, ptr @.cr.1424, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1455, ptr @.cl.1456, i64 %contract.l, ptr @.cr.1457, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1458, ptr @.cl.1459, i64 %contract.l11, ptr @.cr.1460, i64 %contract.r, i32 1)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5314)
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
