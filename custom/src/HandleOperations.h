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
//#include "CustomPlugin.h"
#include "QGCToolbox.h"
#include <QPdfWriter>
#include <QPainter>
#include <QFile>
#include <QTextStream>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QDebug>
#include <QPdfWriter>
#include <QPainter>
#include <QFile>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QDateTime>
#include <QDir>
#include <QDebug>

// Include the required headers


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
    Q_INVOKABLE void userRegistration(QString user, QString pwd, int role);
    Q_INVOKABLE void handleInactiveChanged(int interval);
    Q_INVOKABLE void editUserData(int row, QString id, QString password, int role);
    Q_INVOKABLE QString getDateTime(QString input);

    Q_INVOKABLE bool addRoleConfigfile(QList<QVariant> permission_data, int index);
    Q_INVOKABLE bool deleteRoleConfigfile(QString roleid);
    Q_INVOKABLE QStringList getInitialRoles();

    Q_INVOKABLE void saveToFile(const QString &filePath,QString id);
    void saveJsonToFile(QFile &file,QStringList reportdata);
    void saveCsvToFile(QFile &file,QStringList reportdata) ;
    void savePdfToFile(QString filepath,QStringList reportdata);

    //eventlog
    Q_INVOKABLE void writeDataToFile(const QStringList& dataList);


public slots:
    void getPermissions(QString roleId);
    void inactivityTimeout();

signals:
    void userInactive();

protected:
    bool eventFilter(QObject *obj, QEvent *ev) override;

private:
    static HandleOperations *instance;
    //MultiVehicleManager *m_manager = new MultiVehicleManager(qgcApp(),qgcApp()->toolbox());
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
    uint16_t intactInterval = 20;



    QByteArray configFileData;
    QStringList rolenames;

};

#endif // HANDLEOPERATIONS_H
