#ifndef HANDLEOPERATIONS_H
#define HANDLEOPERATIONS_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QMap>
#include <QStringList>
#include <QDateTime>
#include <QJsonValue>
#include <QMainWindow>
#include <QTimer>
#include <QElapsedTimer>
#include <QMouseEvent>
#include <QKeyEvent>
#include "global.h"
#include "Database.h"
#include "UserRoleModel.h"
#include "CryptoOperations.h"
#include "RolePermissionModel.h"

class HandleOperations : public QObject
{
    Q_OBJECT
public:
    explicit HandleOperations(QObject *parent = nullptr);

    static HandleOperations *getInstance(){
        if(!instance){
            instance = new HandleOperations();
        }
        return instance;
    }

    QString sessionID = "";
    QString currentUser = "";
    void handleUserDataFromDB();
    void readFileData(QString filepath);
    void parseJSON();
    Q_INVOKABLE QStringList getPermListBasedonScreen(QString screenName);
    Q_INVOKABLE QStringList getScreenNames();
    Q_INVOKABLE void setSessionID(QString user);
    Q_INVOKABLE void handleManualLogout();
    Q_INVOKABLE void userRegistration(QString user, QString pwd, QString role);
    Q_INVOKABLE void handleInactiveChanged(int interval);
    Q_INVOKABLE void editUserData(int row, QString id, QString password, QString role);
    Q_INVOKABLE QString getDateTime(QString input);

    Q_INVOKABLE bool addRoleConfigfile(QList<QVariant> permission_data);
    Q_INVOKABLE bool deleteRoleConfigfile(QString roleid);
    Q_INVOKABLE QStringList getInitialRoles();

public slots:
    void getPermissions(QString roleId);
    void inactivityTimeout();

signals:
    void userInactive();

protected:
    bool eventFilter(QObject *obj, QEvent *ev) override;

private:
    static HandleOperations *instance;

    Database *db = Database::getInstance();
    UserRoleModel *roleModel = UserRoleModel::getInstance();
    CryptoOperations *crypto = CryptoOperations::getInstance();
    RolePermissionModel *rolepermModel = RolePermissionModel::getInstance();
    QDateTime *datetime = new QDateTime();

    QMap<QString, QMap<QString,QStringList>> rolePermissions;

    //Based on current selected node
    QMap<QString,QStringList> screenPerm;

    QTimer inactTimer;
    QElapsedTimer elapsedTime;
    uint16_t intactInterval = 45;

    QByteArray configFileData;
    QStringList rolenames;

};

#endif // HANDLEOPERATIONS_H
