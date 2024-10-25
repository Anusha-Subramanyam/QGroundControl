#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <global.h>
#include <QDateTime>
#include <QStringList>
#include <QList>
#include <QSqlRecord>

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
    QVector<USER_DETAILS> userInfo;

    // ~Database();

    QString sessId = "";
    QString currentUser = "";

    int8_t createDatabase(QString templatePath);
    int8_t initDB();
    int8_t openDB();
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

    QSqlDatabase dbase;
    // QString UserID;
    //QString roleID;
    // QString RoleName;

    USER_DETAILS userData;

};

#endif // DATABASE_H
