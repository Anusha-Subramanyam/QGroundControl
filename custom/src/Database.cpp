#include "Database.h"
#include "qsqlquery.h"

Database *Database::instance = nullptr;

Database::Database(QObject *parent)
    : QObject{parent}
{
    qDebug()<<"Plugins loaded: "<<QSqlDatabase::drivers();
}

Database::~Database()
{
    sqlite3_close(db);
}

int8_t Database::initDB()
{
    int8_t sts = FAILURE;

    if(SUCCESS == createDatabase(DB_TEMPLATE_PATH)){
        qDebug()<<"db is created..";
            qDebug()<<"db is created...";
            if(ReadDataDB()){
                sts = SUCCESS;
            }else{
                qDebug()<<"read db error";
            }
    }else{
        qDebug()<<"elseeeeeeee.........";
    }
    return sts;
}

bool Database::openDB()
{
    bool isOpen=true;
    int rc = sqlite3_open(DBPATH, &db);
    if (SQLITE_OK != rc) {
        qDebug() << "Can't open database:" << sqlite3_errmsg(db);
        isOpen = false;
    }

    executeQuery("PRAGMA key = '123';");
    // QString license("PRAGMA cipher_license = '123';");
    // rc = sqlite3_exec(db, license.toStdString().c_str(), NULL, 0, &zErrMsg2);
    // if (SQLITE_OK != rc) {
    //     qDebug() << "pragma license:" << sqlite3_errmsg(db);
    //     isOpen = false;
    // }
    // rc = sqlite3_exec(db, "ATTACH DATABASE 'D:/QGroundControl_TaraUAV/QGroundControl/custom/QGCS_DST.db' AS encrypted KEY '123';", NULL, 0, &zErrMsg2);
    // if (SQLITE_OK != rc) {
    //     qDebug() << "Attach" << sqlite3_errmsg(db);
    //     isOpen = false;
    // }
    // rc = sqlite3_exec(db, "SELECT sqlcipher_export('encrypted');", NULL, 0, &zErrMsg2);
    // if (SQLITE_OK != rc) {
    //     qDebug() << "Select" << sqlite3_errmsg(db);
    //     isOpen = false;
    // }
    // rc = sqlite3_exec(db, "DETACH DATABASE encrypted;", NULL, 0, &zErrMsg2);
    // if (SQLITE_OK != rc) {
    //     qDebug() << "Select" << sqlite3_errmsg(db);
    //     isOpen = false;
    // }


    // if (SQLITE_OK != rc) {
    //     qDebug() << "Can't open database:" << sqlite3_errmsg(db);
    //     isOpen = false;
    // } else {
    //     // Set the SQLCipher license
    //     QString license("PRAGMA cipher_license = '123';");
    //     rc = sqlite3_exec(db, license.toStdString().c_str(), NULL, 0, &zErrMsg2);
    //     if (rc != SQLITE_OK) {
    //         qDebug() << "Failed in license step with error code:" << rc << "Error message:" << zErrMsg;
    //         sqlite3_free(zErrMsg2); // Free the error message
    //         sqlite3_close(db); // Close the database
    //         isOpen = false;
    //     } else {
    //         qDebug() << "License step done";

    //         // Delete the output file if it exists
    //         //deleteFile("outDB.db3");

    //         // Attach the encrypted database
    //         rc = sqlite3_exec(db, "ATTACH DATABASE 'QGCS_DST.db' AS encrypted KEY '123';", NULL, 0, &zErrMsg2);
    //         if (rc != SQLITE_OK) {
    //             qDebug() << "Failed to attach database with error code:" << rc << "Error message:" << zErrMsg;
    //             sqlite3_free(zErrMsg2);
    //             sqlite3_close(db);
    //             isOpen = false;
    //         }
    //     }
    //     isOpen = true;
    // }
    return isOpen;
}



int8_t Database::entriesInDb(QString countQuery, QString tableName)
{
    int8_t entries = FAILURE;
    if((true == openDB()) /*&& (tables.contains(tableName))*/)
    {
        sqlite3_stmt* t_statement;
        int rc = sqlite3_prepare_v2(db, countQuery.toStdString().c_str(), -1, &t_statement, &zErrMsg);
        //        qDebug()<<"sqlite3_prepare_v2 "<<rc;
        if(SUCCESS == rc){
            do
            {
                rc=sqlite3_step(t_statement);
                //            qDebug()<<"sqlite3_prepare_v2 "<<rc;
                if (rc==SQLITE_ROW)
                {
                    int num_cols = sqlite3_column_count(t_statement);

                    for (int columnIndex = 0; columnIndex < num_cols; columnIndex++)
                    {
                        QString data ;
                        switch (sqlite3_column_type(t_statement, columnIndex))
                        {
                        case (SQLITE3_TEXT):{
                            data= reinterpret_cast<const char*>(sqlite3_column_text(t_statement,columnIndex));
                            break;
                        }
                        case (SQLITE_INTEGER):
                            data = QString::number(sqlite3_column_int(t_statement,columnIndex));
                            break;
                        case (SQLITE_FLOAT):
                            data = QString::number(sqlite3_column_int(t_statement,columnIndex));
                            break;
                        default:
                            break;
                        }
                        columsVec.append(data);
                    }
                    mainVec.append(columsVec);
                    columsVec.clear();
                }else if (rc==SQLITE_DONE){
                    entries = SUCCESS;
                    qDebug()<<"entriesInDb successful";
                }else{
                    //qDebug()<<"entriesInDb--error->"<<rc;
                }
            }while (rc==SQLITE_ROW);
        }else{
            qWarning()<<"error while preapering sql statemnt";
        }
        sqlite3_finalize(t_statement);
        //sqlite3_close(db);
    }
    else {
        qDebug()<<" Table Not Open ";
    }
    return entries;
}

int8_t Database::executeQuery(QString sqlStmt)
{
    int8_t exe_query_ret = FAILURE;
    int query = sqlite3_exec(db, sqlStmt.toStdString().c_str(),NULL,0, &zErrMsg2);
    if( query != SQLITE_OK ){
        //qDebug()<<"error "<<zErrMsg2 <<"sql stmt"<<sqlStmt<<"query return"<<query;
        sqlite3_free(zErrMsg2);
    } else {
        //        qDebug()<<"executeQuery successful--->"<<sqlStmt;
        exe_query_ret = SUCCESS;
    }
    return exe_query_ret;
}

int8_t Database::listOfTablesInDb()
{
    int8_t table_list_ret = FAILURE;
    QString sql = "SELECT * FROM sqlite_master where type='table'";
    if(SUCCESS == entriesInDb(sql,"")){
        for(int i=0;i<mainVec.size();i++){
            tables.append(mainVec.at(i).at(1));
        }
        mainVec.clear();
        table_list_ret = SUCCESS;
    }else{
    }
    return table_list_ret;
}

int8_t Database::createDatabase(QString templatePath)
{
    qDebug()<<"CREATE DATABASE";
    int8_t status = FAILURE;

    if(!QFile::exists(DBPATH))
    {
        if(true == openDB()){
            qDebug()<<"Opened database successfully\n";
            if(QFile::exists(templatePath)){
                QFile file(templatePath);

                file.open(QIODevice::ReadOnly | QIODevice::Text);
                QTextStream in(&file);
                QString sql = in.readAll();
                if (sql.trimmed() != "")
                {
                    qDebug()<<"Data in sql template: "<<sql.trimmed();
                    executeQuery("PRAGMA key = '123';");
                    executeQuery(sql);
                }
                else {
                    /// Do nothing...
                }
                listOfTablesInDb();
                //sqlite3_close(db);
                status=SUCCESS;
            }
            else{
                qDebug()<<"template file is not present";//template file is not present
            }
        }
        else{
            qDebug()<<"Db is not open";
        }
    }
    else{
        qDebug()<<"db file already exists"; //db file already exists
        if(true == openDB()){
            listOfTablesInDb();
            // insrtintoDB();
            //sqlite3_close(db);
            status=SUCCESS;
        }
        else{
            qDebug()<<"Db is not open";
        }
    }
    return status;
}

bool Database::ReadDataDB()
{
    qDebug()<<"Reading Database";
    bool status = false;

    QString sql = "SELECT * FROM UserData;";

    if(SUCCESS == entriesInDb(sql,"UserData")){
        qDebug()<<"Inside the UserData info details";
        //qDebug()<<mainVec;
        userData.clear();
        userData = mainVec;
        mainVec.clear();
        userInfo.clear();
        int rowCount = userData.size();
        //qDebug()<<"ROW COUNT-----------------------"<<rowCount;
        userInfo.resize(rowCount);
        if(!userData.isEmpty() && !userData.at(0).isEmpty()){
            //wifiDetailsAvl = true;

            int counter;
            for(counter=0;counter<rowCount;counter++){
                userInfo[counter].UserId = userData.at(counter).at(0);
                userInfo[counter].Password = userData.at(counter).at(1);
                userInfo[counter].IsActive = userData.at(counter).at(2);
                userInfo[counter].Role = userData.at(counter).at(3);
                userInfo[counter].UserSince = userData.at(counter).at(4);
                userInfo[counter].LastLogin = userData.at(counter).at(5);
            }
        }else{
            ;
        }
        userData.clear();
        status = true;
        //qDebug()<<"Emit User Details Changed: "<<userInfo;

        emit userDetailsFetched();
    }
    return status;
}

void Database::setSessionLogin(QString id, QString user, QString timeStmp)
{
    qDebug()<<"Setting Session Login";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while writing session login";
    // }else{
        sessId = id;
        QSqlQuery sql;;
        sql.prepare("INSERT INTO SessionLogs (SessionId, UserId, LoginTimeStamp) VALUES (? ,? ,?)");
        sql.addBindValue(id);
        sql.addBindValue(user);
        sql.addBindValue(timeStmp);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"Succesful SessionLogin";

        }
    //}
}

void Database::setSessionLogout()
{
    qDebug()<<"Setting Session Logout";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while writing session logout";
    // }else{
        QSqlQuery sql;
        sql.prepare("UPDATE SessionLogs SET LogoutTimeStamp = ? WHERE SessionId = ?");
        sql.addBindValue(QDateTime::currentDateTime().toString("yyyyMMddhhmmss"));
        sql.addBindValue(sessId);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"Succesful SessionLogout";
        }
    //}


}

void Database::updateUserParameter(QString user, QString parameter, QString val)
{
    qDebug()<<"Updating isActive";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while updating isActive";
    // }else{
        QSqlQuery sql;
        sql.prepare("UPDATE UserData SET "+ parameter +" = ? WHERE UserId = ?");
        sql.addBindValue(val);
        sql.addBindValue(user);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            //qDebug()<<"Succesful isActive Update: "<<sts<<" "<<user;
        }
    //}
}


void Database::addUser(QString user, QString password, QString role, QString timestamp)
{
    qDebug()<<"Adding new user";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while adding new user";
    // }else{
        QSqlQuery sql;
        sql.prepare("INSERT INTO UserData (UserId, Password, IsActive, RoleID, UserSince, LastLogin) VALUES (? ,? ,?, ?, ?, ?)");
        sql.addBindValue(user);
        sql.addBindValue(password);
        sql.addBindValue(0);
        sql.addBindValue(role);
        sql.addBindValue(timestamp);
        sql.addBindValue("-");
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"Succesful Adding of New User";
        }
    //}
}

int Database::numberofRowsDB()
{
    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM table_name");
    if (query.exec()) {
        if (query.next()) {
            int rowCount = query.value(0).toInt();
            return rowCount;
        }
    } else {
        qDebug() << "Query failed:" ;
    }
    return -1;
}

QList<QStringList> Database::getActivityLogs(int offset)
{
    QList<QStringList> results;
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while adding new user";
    //     return results;
    // }else{
        int rowcount =numberofRowsDB();
        int diffrowAndoffset =rowcount-offset;
        int limitValue = 0;
        if(diffrowAndoffset<10){
            limitValue =diffrowAndoffset;
        }else{
            limitValue = 10;
        }


        QSqlQuery sql;
        sql.prepare("SELECT * FROM ActivityLogs LIMIT :limit OFFSET :offset");
        sql.bindValue(":limit", limitValue);
        sql.bindValue(":offset", offset);
        if(sql.exec()){
            while (sql.next()) {
                QStringList row;  // To store the columns of the current row
                for (int i = 0; i < sql.record().count(); ++i) {
                    row.append(sql.value(i).toString());  // Append each column value to the row
                }
                results.append(row);
            }

        }
        else{
            qDebug()<<"UnSuccesful Adding of Activitylogs";

        }
    //}
    return results;
}

void Database::insertActivityLogs(QString Activity, QString Description)
{
    qDebug()<<"Adding Activity Logs";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while adding new user";
    // }else{
        QSqlQuery sql;
        sql.prepare("INSERT INTO ActivityLogs (Timestamp,UserId,Activity,Description) VALUES (? ,? ,?, ?)");
        sql.addBindValue(QDateTime::currentDateTime().toString("yyyyMMddhhmmss"));
        sql.addBindValue(currentUser);
        sql.addBindValue(Activity);
        sql.addBindValue(Description);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"Succesful Adding activity logs";

        }
    //}
}

void Database::deleteUser(QString userID)
{
    qDebug()<<"Deleting user";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while adding new user";
    // }else{
        QSqlQuery sql;
        sql.prepare("DELETE FROM UserData WHERE UserId = ?");
        sql.addBindValue(userID);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"User Deleted";

        }
    //}
}

void Database::editData(int index,QString userID, QString pass, QString role)
{
    qDebug()<<"Editing User";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while adding new user";
    // }else{
        QSqlQuery sql;
        sql.prepare("UPDATE UserData SET UserId = ?, Password = ?, RoleID  = ? WHERE ROWID = ?");
        sql.addBindValue(userID);
        sql.addBindValue(pass);
        sql.addBindValue(role);
        sql.addBindValue(index+1);

        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"User Deleted";

        }
    //}
}

void Database::setInactivityTimeout(int timeSecs)
{
    qDebug()<<"Editing Inactivity Timeout";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while editing inactivity timeout";
    // }else{
        QSqlQuery sql;
        sql.prepare("UPDATE Settings SET InactivityTimeout = ?");
        sql.addBindValue(timeSecs);

        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            //qDebug()<<"Changed Inactivity Timeout to "<<timeSecs;
        }
    //}
}

int Database::getInactivityTimeout()
{
    qDebug()<<"Reading Inactivity Timeout";
    int timeout = 0;
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while reading inactivity timeout";
    // }else{
        QSqlQuery sql;
        sql.prepare("SELECT * FROM Settings");
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            while(sql.next()){
                timeout = sql.value(0).toInt();
            }
        }
    //}
    return timeout;
}

void Database::insertMissionHistory(QVariantList data)
{
    qDebug()<<"Adding Mission History Data";
    // if(openDB() != SUCCESS){
    //     qDebug()<<"DB Open Failed while adding mission history data";
    // }else{
        QSqlQuery sql;
        sql.prepare("INSERT INTO CustomReportData (VehicleID , VehicleType , FirmwareType, MissionTime) VALUES (? ,? ,?,?)");
        sql.addBindValue(data.at(0));
        sql.addBindValue(data.at(1));
        sql.addBindValue(data.at(2));
        sql.addBindValue(QDateTime::currentDateTime().toString("yyyyMMddhhmmss"));
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"Succesful Adding of Mission History Data";
        }
    //}
}

QVariantList Database::readMissionHistory(QString vehID, bool flag)
{
    qDebug()<<"Reading Mission History Data "<<flag<<" "<<vehID;
    QVariantList results;
    QSqlQuery sql;
    if(flag == true){
        sql.prepare("SELECT * FROM CustomReportData WHERE VehicleID = ?");
        sql.addBindValue(vehID);
    }else{
        sql.prepare("SELECT VehicleID, VehicleType, MissionTime FROM CustomReportData WHERE VehicleID = ?");
        sql.addBindValue(vehID);
    }
    if(sql.exec()){
        while (sql.next()) {
            QStringList row;  // To store the columns of the current row
            for (int i = 0; i < sql.record().count(); ++i) {
                row << sql.value(i).toString();  // Append each column value to the row
            }
            results << row;
        }
    }
    else{
        qDebug()<<"UnSuccesful Reading of Mission History Data";
    }
    return results;
}
