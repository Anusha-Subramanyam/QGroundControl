#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <global.h>
#include <QDateTime>
#include <QStringList>
#include <QList>
#include <QSqlRecord>
#include <sqlite3.h>
#include <sqlcipher.h>

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = nullptr);

    static Database *getInstance(){
        if(!instance){
            instance = new Database();
        }
        return instance;
    }
    QVector<QVector<QString>> userData;
    QVector<USER_DETAILS> userInfo;


    ~Database();

    QString sessId = "";
    QString currentUser = "";

    int8_t createDatabase(QString templatePath);
    int8_t initDB();
    bool openDB();
    int8_t entriesInDb(QString countQuery, QString tableName);
    int8_t executeQuery(QString sqlStmt);
    int8_t listOfTablesInDb();
    bool ReadDataDB();
    void setSessionLogin(QString id, QString user, QString timeStmp);
    Q_INVOKABLE void setSessionLogout();
    Q_INVOKABLE void updateUserParameter(QString user, QString parameter, QString val);
    void addUser(QString user, QString password, QString role, QString timestamp);
    Q_INVOKABLE int  numberofRowsDB();
    Q_INVOKABLE QList<QStringList> getActivityLogs(int offset);
    Q_INVOKABLE void insertActivityLogs(QString Activity, QString Description);
    Q_INVOKABLE void deleteUser(QString userID);
    void editData(int index,QString userID,QString pass, QString role);
    Q_INVOKABLE void setInactivityTimeout(int timeSecs);
    Q_INVOKABLE int getInactivityTimeout();
    Q_INVOKABLE void insertMissionHistory(QVariantList data);
    Q_INVOKABLE QVariantList readMissionHistory(QString vehID, bool flag);


    // QString getUserID();
    //QString getRoleID();
    // QString getRoleName();

    // void setUserID(QString userid);
    //void setRoleID(QString userRole);
    // void setRoleName(QString name);

signals:
    // void userIDChanged();
    //void roleIDChanged();
    // void roleNameChanged();
    void userDetailsFetched();

private:
    static Database *instance;

    sqlite3 *db=nullptr;
    //QSqlDatabase dbase;
    // QString UserID;
    //QString roleID;
    // QString RoleName;

    //USER_DETAILS userData;
    QList<QString> tables;
    QVector<QString> columsVec;
    QVector<QVector<QString>> mainVec;
    const char *zErrMsg = 0;
    char *zErrMsg2 = 0;
};

#endif // DATABASE_H
