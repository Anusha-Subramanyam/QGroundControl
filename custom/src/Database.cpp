#include "Database.h"
#include "qsqlquery.h"

Database *Database::instance = nullptr;

Database::Database(QObject *parent)
    : QObject{parent}
{
    dbase = QSqlDatabase::addDatabase("QSQLITE");
    dbase.setDatabaseName(DBPATH);
}

int8_t Database::initDB()
{
    int8_t sts = FAILURE;
    if((SUCCESS == openDB()) && (true == dbase.tables().contains(QLatin1String(USER_TABLE))))
    {
        ReadDataDB();
        sts = SUCCESS;
    }
    else
    {   if(SUCCESS == createDatabase(DB_TEMPLATE_PATH)){
            ReadDataDB();
            sts = SUCCESS;
        }
        else{;}
    }
    return sts;
}

int8_t Database::openDB()
{
    int8_t status = FAILURE;
    if(false == dbase.isOpen()){
        if(false == dbase.open()){
            status = FAILURE;
        }else{
            status = SUCCESS;
        }
    }
    else{
        status = SUCCESS;
    }
    return status;
}

int8_t Database::createDatabase(QString templatePath)
{
    qDebug()<<"CREATE DATABASE";
    int8_t status = FAILURE;
    if(QFile::exists(templatePath)){
        QFile tempFile(templatePath);
        if(tempFile.open(QIODevice::ReadOnly | QIODevice::Text)){
            QTextStream in(&tempFile);
            QString dbTemp = in.readAll();
            if(dbTemp.trimmed() != ""){
                QStringList queries = dbTemp.split(';',QString::SkipEmptyParts);
                int succCnt = 0;
                foreach(const QString& query, queries)
                {
                    QSqlQuery *qry = new QSqlQuery(dbase);
                    qry->prepare(query);
                    qDebug()<<"[Creating DB From Template] "<<succCnt<<" "<<query;
                    if (qry->exec()){
                        succCnt++;
                        status = SUCCESS;
                    }
                    else
                    {
                        status = FAILURE;
                        qDebug()<<"DB Template Query failed at "<<succCnt;
                        break;
                    }
                    qry->clear();
                    delete qry;

                }
            }

        }
    }else{
        qDebug()<<"DB Template Not found";
    }
    return status;
}

bool Database::ReadDataDB()
{
    qDebug()<<"Reading Database";
    bool status = false;
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while reading user data";
    }else{
        QSqlQuery sql;
        sql.prepare("SELECT * FROM UserData");
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            userInfo.clear();
            while(sql.next()){
                userData = {};
                userData.UserId = sql.value(0).toString();
                userData.Password = sql.value(1).toString();
                userData.IsActive = sql.value(2).toString();
                userData.Role = sql.value(3).toString();
                userData.UserSince = sql.value(4).toString();
                userData.LastLogin = sql.value(5).toString();
                userInfo.append(userData);
            }
            status = true;
            qDebug()<<"Emit User Details Changed";
            emit userDetailsFetched();
        }
    }

    return status;
}

void Database::setSessionLogin(QString id, QString user, QString timeStmp)
{
    qDebug()<<"Setting Session Login";
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while writing session login";
    }else{
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
    }
}

void Database::setSessionLogout()
{
    qDebug()<<"Setting Session Logout";
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while writing session logout";
    }else{
        QSqlQuery sql;
        sql.prepare("UPDATE SessionLogs SET LogoutTimeStamp = ? WHERE SessionId = ?");
        sql.addBindValue(QDateTime::currentDateTime().toString("yyyyMMddhhmmss"));
        sql.addBindValue(sessId);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"Succesful SessionLogout";
        }
    }
}

void Database::updateUserParameter(QString user, QString parameter, QString val)
{
    qDebug()<<"Updating isActive";
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while updating isActive";
    }else{
        QSqlQuery sql;
        sql.prepare("UPDATE UserData SET "+ parameter +" = ? WHERE UserId = ?");
        sql.addBindValue(val);
        sql.addBindValue(user);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            //qDebug()<<"Succesful isActive Update: "<<sts<<" "<<user;
        }
    }
}


void Database::addUser(QString user, QString password, QString role, QString timestamp)
{
    qDebug()<<"Adding new user";
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while adding new user";
    }else{
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
    }
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
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while adding new user";
        return results;
    }else{
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
                    row << sql.value(i).toString();  // Append each column value to the row
                }
                results << row;
            }

        }
        else{
            qDebug()<<"UnSuccesful Adding of Activitylogs";

        }
    }
    return results;
}

void Database::insertActivityLogs(QString Activity, QString Description)
{
    qDebug()<<"Adding Activity Logs";
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while adding new user";
    }else{
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
    }
}

void Database::deleteUser(QString userID)
{
    qDebug()<<"Deleting user";
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while adding new user";
    }else{
        QSqlQuery sql;
        sql.prepare("DELETE FROM UserData WHERE UserId = ?");
        sql.addBindValue(userID);
        if(!sql.exec()){
            qDebug()<<"Query Failed";
        }else{
            qDebug()<<"User Deleted";

        }
    }
}

void Database::editData(int index,QString userID, QString pass, QString role)
{
    qDebug()<<"Editing User";
    if(openDB() != SUCCESS){
        qDebug()<<"DB Open Failed while adding new user";
    }else{
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
    }
}

