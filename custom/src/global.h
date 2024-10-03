#ifndef GLOBAL_H
#define GLOBAL_H
#include <QString>
#include <QVector>
#include <stdint.h>

typedef struct{
    QString UserId;
    QString Password;
    QString IsActive;
    QString Role;
    QString UserSince;
    QString LastLogin;
    QString EditUser;
    QString DeleteUser;
}USER_DETAILS;

typedef struct{
    QString RoleId;
    QString RoleName;
    QString Description;
    QJsonObject Permissions;
    QString EditRole;
    //QString DeleteRole;
}ROLE_DETAILS;

#define DBPATH "D:/QGroundControl_TaraUAV/QGroundControl/custom/QGCS_DST.db" //"D:/QGC/qgroundcontrol/QGCS_DST.db"
#define DB_TEMPLATE_PATH "D:/QGroundControl_TaraUAV/QGroundControl/custom/db_qgc_template.sql" //"D:/QGC/qgroundcontrol/db_qgc_template.sql"
#define CONFIG_FILE_PATH "D:/QGroundControl_TaraUAV/QGroundControl/custom/userRoles.json"
#define USER_TABLE "UserData"

#define SUCCESS 0
#define FAILURE -1

#endif // GLOBAL_H
