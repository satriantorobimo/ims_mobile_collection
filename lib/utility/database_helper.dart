import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_model.dart';
import 'package:mobile_collection/feature/login/data/auth_response_model.dart';
import 'package:mobile_collection/feature/login/data/login_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:synchronized/synchronized.dart';

import '../feature/assignment/data/task_list_response_model.dart';

import 'package:mobile_collection/feature/invoice_history/data/history_response_model.dart'
    as hstry;
import 'package:mobile_collection/feature/amortization/data/amortization_response_model.dart'
    as amor;

import 'package:mobile_collection/feature/home/data/dashboard_response_model.dart'
    as dshb;

class DatabaseHelper {
  static final _lock = Lock();
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        uid TEXT,
        name TEXT,
        system_date TEXT,
        branch_code TEXT,
        branch_name TEXT,
        idpp TEXT,
        company_code TEXT,
        company_name TEXT,
        idle_time TEXT,
        is_watermark TEXT
      )
      """);

    await database.execute("""CREATE TABLE datelogin(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        date TEXT,
        uid TEXT
      )
      """);

    await database.execute("""CREATE TABLE cust(
        client_no TEXT PRIMARY KEY,
        client_name TEXT,
        invoice_count INTEGER,
        task_date TEXT,
        task_status TEXT,
        phone_no_1 TEXT,
        phone_no_2 TEXT,
        overdue_installment DOUBLE,
        full_address TEXT,
        address TEXT,
        rt TEXT,
        rw TEXT,
        village TEXT,
        sub_district TEXT,
        city_name TEXT,
        province_name TEXT,
        zip_code TEXT,
        latitude TEXT,
        longitude TEXT
      )
      """);

    await database.execute("""CREATE TABLE agreement(
        task_id INTEGER PRIMARY KEY,
        agreement_no TEXT,
        client_no TEXT,
        collateral_no TEXT,
        overdue_days INTEGER,
        overdue_period INTEGER,
        overdue_installment_amount DOUBLE,
        last_paid_installment_no INTEGER,
        installment_due_date TEXT,
        installment_amount double,
        result_code TEXT,
        result_remarks TEXT,
        result_promise_date TEXT,
        result_payment_amount DOUBLE,
        tenor INTEGER,
        plat_no TEXT,
        vehicle_description TEXT,
        vehicle_condition TEXT,
        sync INTEGER
      )
      """);

    await database.execute("""CREATE TABLE amortization(
        agreement_no TEXT PRIMARY KEY,
        installment_no INTEGER,
        due_date TEXT,
        installment_amount DOUBLE,
        os_principal_amount DOUBLE
      )
      """);

    await database.execute("""CREATE TABLE paymentlist(
        agreement_no TEXT PRIMARY KEY,
        payment_date TEXT,
        payment_source_type TEXT,
        payment_amount DOUNLE
      )
      """);

    await database.execute("""CREATE TABLE history(
        agreement_no TEXT PRIMARY KEY,
        installment_no INTEGER,
        installment_amount DOUBLE,
        result_code TEXT,
        result_promise_date TEXT,
        result_payment_amount DOUBLE,
        result_remarks TEXT,
        mod_date TEXT
      )
      """);

    await database.execute("""CREATE TABLE dailystatus(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        result_status TEXT,
        result_count INTEGER
      )
      """);

    await database.execute("""CREATE TABLE achieve(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        category TEXT,
        daily_count TEXT,
        daily_target TEXT,
        monthly_count TEXT,
        monthly_target TEXT
      )
      """);

    await database.execute("""CREATE TABLE attachment(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        task_id INTEGER,
        path TEXT,
        basename TEXT,
        ext TEXT,
        size TEXT,
        date TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'salesorder.db',
      version: 8,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Insert Cust
  static Future<void> insertCust(List<Data> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('cust', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.replace);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });

    //  return _lock.synchronized(() async{});
  }

  // Insert Cust
  static Future<void> insertDateLogin(List<LoginModel> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('datelogin', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.replace);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });

    //  return _lock.synchronized(() async{});
  }

  // Insert Attachment
  static Future<void> insertAttachment(List<Attachment> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('attachment', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.replace);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });

    //  return _lock.synchronized(() async{});
  }

  // Insert History
  static Future<void> insertHistory(List<hstry.Data> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('history', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });
  }

  // Insert Amortization
  static Future<void> insertAmortization(List<amor.Data> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('amortization', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });
  }

  // Insert History
  static Future<void> insertPaymentList(List<amor.PaymentList> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('paymentlist', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });
  }

  // Insert Cust
  static Future<void> insertAgreement(List<AgreementList> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('agreement', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });
  }

  // Insert daily
  static Future<void> insertDasilyStatus(
      List<dshb.DailyTaskStatus> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('dailystatus', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });
  }

  // Insert Achievement
  static Future<void> insertAchievement(List<dshb.Achievement> data) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();
        Batch batch = db.batch();
        for (var val in data) {
          batch.insert('achieve', val.toMap(),
              conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        }
        batch.commit();
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });
  }

  // Insert user
  static Future<void> insertUser(Datalist datalist) async {
    return _lock.synchronized(() async {
      try {
        final db = await DatabaseHelper.db();

        await db.insert('user', datalist.toMap(),
            conflictAlgorithm: sql.ConflictAlgorithm.ignore);
        await db.close();
      } catch (e) {
        dev.log('Error $e');
      }
    });
  }

  // Read all cust
  static Future<List<Data>> getCust() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db.query('cust');
      await db.close();
      return List.generate(maps.length, (i) {
        return Data.fromMap(maps[i]);
      });
    });
  }

  // Read single cust
  static Future<List<Map<String, dynamic>>> getSingleCust(
      String clientNo) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      return db.query('cust', where: "client_no = ?", whereArgs: [clientNo]);
    });
  }

  // Read all agreement
  static Future<List<Data>> getAgreement() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db.query('agreement');
      await db.close();
      return List.generate(maps.length, (i) {
        return Data.fromMap(maps[i]);
      });
    });
  }

  // Read all attachment
  static Future<List<Attachment>> getAttachment(String taskId) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db
          .query('attachment', where: "task_id != ?", whereArgs: [taskId]);
      await db.close();
      return List.generate(maps.length, (i) {
        return Attachment.fromMap(maps[i]);
      });
    });
  }

  // Read all agreement
  static Future<List<dshb.DailyTaskStatus>> getDailyStatus() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db.query('dailystatus');
      await db.close();
      return List.generate(maps.length, (i) {
        return dshb.DailyTaskStatus.fromMap(maps[i]);
      });
    });
  }

  // Read all agreement
  static Future<List<dshb.Achievement>> getAchievement() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db.query('achieve');
      await db.close();
      return List.generate(maps.length, (i) {
        return dshb.Achievement.fromMap(maps[i]);
      });
    });
  }

  // Read all history
  static Future<List<hstry.Data>> getHistory(String agreementNo) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db.query('history',
          where: "agreement_no = ?", whereArgs: [agreementNo]);
      await db.close();
      return List.generate(maps.length, (i) {
        return hstry.Data.fromMap(maps[i]);
      });
    });
  }

  // Read all amortization
  static Future<List<amor.Data>> getAmortization(String agreementNo) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db.query('amortization',
          where: "agreement_no = ?", whereArgs: [agreementNo]);
      await db.close();
      return List.generate(maps.length, (i) {
        return amor.Data.fromMap(maps[i]);
      });
    });
  }

  // Read all amortization
  static Future<List<amor.PaymentList>> getPaymentList(
      String agreementNo) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db.query('paymentlist',
          where: "agreement_no = ?", whereArgs: [agreementNo]);
      await db.close();
      return List.generate(maps.length, (i) {
        return amor.PaymentList.fromMap(maps[i]);
      });
    });
  }

  // Read single agreement
  static Future<List<Map<String, dynamic>>> getSingleAgreement(
      String clientNo) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      return db
          .query('agreement', where: "client_no = ?", whereArgs: [clientNo]);
    });
  }

  // Read all agreement
  static Future<List<Data>> getAgreementSync() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps =
          await db.query('agreement', where: "sync = ?", whereArgs: [1]);
      await db.close();
      return List.generate(maps.length, (i) {
        return Data.fromMap(maps[i]);
      });
    });
  }

  // Read all agreement
  static Future<List<Data>> getAgreementDone() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> maps = await db
          .query('agreement', where: "result_code != ?", whereArgs: [""]);
      await db.close();
      return List.generate(maps.length, (i) {
        return Data.fromMap(maps[i]);
      });
    });
  }

  // Update an task by id
  static Future<void> updateAgreement(
      {int? taskId,
      String? resultCode,
      String? resultRemark,
      String? resultPromiseDate,
      String? resultPaymentAmount,
      int? isSync}) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();

      await db.rawUpdate(
          'UPDATE agreement SET result_code = ?, result_remarks = ?, result_promise_date = ?, result_payment_amount = ?, sync = ?  WHERE task_id = ?',
          [
            resultCode,
            resultRemark,
            resultPromiseDate,
            resultPaymentAmount,
            isSync,
            taskId
          ]);
      await db.close();
    });
  }

  // Update an task by id
  static Future<void> updateDateLogin({String? date, String? uid}) async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();

      await db.rawUpdate(
          'UPDATE datelogin SET date = ?  WHERE uid = ?', [date, uid]);
      await db.close();
    });
  }

  // User Data by ID
  static Future<List<Map<String, dynamic>>> getUserData() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      return db.query('user', limit: 1);
    });
  }

  // User Data by ID
  static Future<List<Map<String, dynamic>>> getDateLogin() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      return db.query('datelogin', limit: 1);
    });
  }

  // User Data by ID
  static Future<List<Map<String, dynamic>>> getUserData2() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      return db.query('user', limit: 1);
    });
  }

  // Delete
  static Future<void> deleteUser() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      try {
        await db.delete('user');
      } catch (err) {
        debugPrint("Something went wrong when deleting an item: $err");
      }
    });
  }

  // Delete
  static Future<void> deleteData() async {
    return _lock.synchronized(() async {
      final db = await DatabaseHelper.db();
      try {
        await db.delete('cust');
        await db.delete('agreement');
        await db.delete('amortization');
        await db.delete('paymentlist');
        await db.delete('history');
        await db.delete('dailystatus');
        await db.delete('achieve');
        await db.delete('attachment');
      } catch (err) {
        debugPrint("Something went wrong when deleting an item: $err");
      }
    });
  }
}
