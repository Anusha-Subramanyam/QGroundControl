#include "HandleOperations.h"
HandleOperations *HandleOperations::instance = nullptr;

HandleOperations::HandleOperations(QObject *parent)
    : QObject{parent}
{
    qDebug()<<"In Handle Operation Class";
    readFileData(CONFIG_FILE_PATH);

    /*"D:/QGC/Resources/Images/userRoles.json"*/
    QApplication::instance()->installEventFilter(this);

    /***************Connections: Database *********************************/
    QObject::connect(db,&Database::userDetailsFetched,this,[=](){
        qDebug()<<"Connection called";
        handleUserDataFromDB();
    });

    QObject::connect(roleModel,&UserRoleModel::currentSelectedRoleChanged,this,[=](QString role){
        getPermissions(role);
        db->currentUser = roleModel->getCurrentSelectedUser();
        inactTimer.start();
        if(!elapsedTime.isValid()){
            elapsedTime.start();
        }else{
            elapsedTime.restart();
        }
    });
    QObject::connect(&inactTimer,&QTimer::timeout,this,[=](){
        qDebug()<<"Inactive signal triggered";
        inactivityTimeout();
    });
    qDebug()<<"Initial timer started";
    inactTimer.setInterval(5000);

    if(db->initDB() == SUCCESS){
    }
}

void HandleOperations::handleUserDataFromDB()
{
    qDebug()<<"Storing DB User Data to Model";
    for(int cnt = 0;cnt<db->userInfo.length();cnt++){
        //Password decryption
        //qDebug()<<"ENCRYPT: "<<crypto->encryption("123");
        //QString text = "moM7qNdo71uUr4s7B8XWVw==";
        //qDebug()<<"DECRYPT: "<<crypto->decryption(text.toLocal8Bit());
        QString decrypt = crypto->decryption(db->userInfo.at(cnt).Password.toLocal8Bit());
        roleModel->addData(db->userInfo.at(cnt).UserId,decrypt,db->userInfo.at(cnt).IsActive, db->userInfo.at(cnt).Role,db->userInfo.at(cnt).UserSince,db->userInfo.at(cnt).LastLogin);
        qDebug()<<"DATA at "<<cnt<<" "<<db->userInfo.at(cnt).UserId<<" "<<db->userInfo.at(cnt).Password<<":"<<decrypt<<" "<<db->userInfo.at(cnt).IsActive<<" "<<db->userInfo.at(cnt).Role<<" "<<db->userInfo.at(cnt).UserSince<<" "<<db->userInfo.at(cnt).LastLogin;
    }
}

void HandleOperations::readFileData(QString filepath)
{
    qDebug()<<"Reading Data from Config File ... ";
    QFile file(filepath);
    if(!file.open(QIODevice::ReadOnly)){
        qDebug()<<"Failed to open config file";
        return;
    }
    configFileData = file.readAll();
    qDebug()<<"FILE DATA: "<<configFileData;
    parseJSON();
}

void HandleOperations::parseJSON()
{
    qDebug()<<"ParseXML Function Called ... ";
    rolenames.clear();
    QJsonDocument document(QJsonDocument::fromJson(configFileData));
    if(document.isEmpty() || !document.isObject()){
        qDebug()<<"Failed to parse Config File";
        return;
    }

    QJsonObject roles = document.object().value("roles").toObject();

    qDebug()<<"ROLEID: "<<roles.keys();
    for(const QString &roleId : roles.keys()){
        QJsonObject roleObject = roles.value(roleId).toObject();
        QString roleName = roleObject.value("role").toString();
        rolenames.append(roleName);
        QString roleDescription = roleObject.value("description").toString();
        QJsonObject permission = roleObject.value("permission").toObject();

        qDebug()<<"RoleId in JSON: "<<roleId;
        qDebug()<<"RoleName in JSON: "<<roleName;
        QMap<QString, QStringList> screenPerm;

        for (const QString &screen : permission.keys()) {
            QJsonArray permissionsArray = permission.value(screen).toArray();
            QStringList permissions;

            qDebug()<<"Screen Permissions in JSON: "<<screen;

            for (const QJsonValue &permission : permissionsArray) {
                QString permissionString = permission.toString();
                if (permissionString == "*") {
                    permissions << "*";  // Indicating full access to the screen
                } else {
                    permissions << permissionString;
                }
                qDebug()<<screen<<" "<<permissionString;
            }
            screenPerm.insert(screen, permissions);
        }
        rolepermModel->addRoleData(roleId,roleName,roleDescription,permission);
        rolePermissions.insert(roleId,screenPerm);
    }
    qDebug()<<"Length: "<<rolenames.length();
    qDebug()<<"Data:"<<rolenames;
}

QStringList HandleOperations::getPermListBasedonScreen(QString screenName)
{
    qDebug()<<"Get Permissions based on Screen Name: "<<screenName;
    QStringList data;
    if(screenPerm.keys().contains(screenName)){
        data = screenPerm.value(screenName);
    }
    return data;
    qDebug()<<"Value Returned: "<<screenPerm.value(screenName);
}

QStringList HandleOperations::getScreenNames()
{
    QStringList screenNames;
    screenNames = screenPerm.keys();
    return screenNames;
}

void HandleOperations::setSessionID(QString user)
{
    QString timestamp = datetime->currentDateTime().toString("yyyyMMddhhmmss");
    sessionID = "";
    sessionID = user+"_"+timestamp;
    qDebug()<<"Session ID Generated: "<<sessionID;

    db->setSessionLogin(sessionID, user, timestamp);
    db->updateUserParameter(user,"IsActive" ,"1");
    db->updateUserParameter(user,"LastLogin" ,timestamp);
}

void HandleOperations::handleManualLogout()
{
    db->setSessionLogout();
    db->updateUserParameter(roleModel->getCurrentSelectedUser(),"IsActive","0");
    QModelIndex ind = roleModel->index(roleModel->getModelIndex(roleModel->getCurrentSelectedUser()),0);
    roleModel->setData(ind,"0",UserRoleModel::ActiveStatus);
    inactTimer.stop();
    elapsedTime.invalidate();
}

void HandleOperations::userRegistration(QString user, QString pwd, QString role)
{
    QString userSince = QDateTime::currentDateTime().toString("yyyyMMddhhmmss");
    roleModel->addData(user,pwd,0,role,userSince,"-");
    QString encyptPass = crypto->encryption(pwd);
    db->addUser(user,encyptPass,role,userSince);
}

void HandleOperations::handleInactiveChanged(int interval)
{
    if(inactTimer.isActive()){
        qDebug()<<"Inact Timer Stopped";
        inactTimer.stop();
    }
    intactInterval = interval;
    inactTimer.start();
    elapsedTime.restart();
}

void HandleOperations::editUserData(int row, QString id, QString password, QString role)
{
    db->editData(row,id,password,role);
    QModelIndex ind = roleModel->index(row-1,0);
    roleModel->setData(ind,id,UserRoleModel::UserID);
    roleModel->setData(ind,password,UserRoleModel::Password);
    roleModel->setData(ind,role,UserRoleModel::UserRole);
}

QString HandleOperations::getDateTime(QString input)
{
    QString result = "";
    QDateTime dateTime = QDateTime::fromString(input, "yyyyMMddhhmmss");
    result = dateTime.date().toString() + ", " +dateTime.time().toString();
    return result;
}

bool HandleOperations::addRoleConfigfile(QList<QVariant> permission_data)
{
    // Parse the JSON data
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(configFileData, &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "Error parsing JSON: " << parseError.errorString();
        return false;
    }

    // Convert to QJsonObject
    QJsonObject jsonObj = jsonDoc.object();

    // Access the "roles" section
    if (jsonObj.contains("roles") && jsonObj["roles"].isObject()) {
        QJsonObject rolesObj = jsonObj["roles"].toObject();

        // Check if "1" already exists, if not add it
        if (!rolesObj.contains(permission_data.at(0).toString())) {
            // Create the "1" (Admin role) JSON object
            QJsonObject adminRoleObj;
            adminRoleObj["role"] = permission_data.at(1).toString();
            adminRoleObj["description"] = permission_data.at(2).toString();

            QJsonObject permissionObj;
            permissionObj["FlyView"] = QJsonArray(permission_data.at(3).toJsonArray());
            permissionObj["Menu"] = QJsonArray(permission_data.at(4).toJsonArray());
            qDebug()<<"................................................................";
            qDebug()<<permission_data.at(4).Size;
            // QVariant variant = permission_data.at(4);
            if(!permission_data.at(4).toList().isEmpty()){
                permissionObj["AnalyzeTools"] = QJsonArray(permission_data.at(5).toJsonArray());
            }
            if(!permission_data.at(5).toList().isEmpty()){
                permissionObj["AppSettings"] = QJsonArray(permission_data.at(6).toJsonArray());
            }


            adminRoleObj["permission"] = permissionObj;

            rolepermModel->addRoleData(permission_data.at(0).toString(),permission_data.at(1).toString(), permission_data.at(2).toString(),permissionObj);

            // Add "1" to the roles object
            rolesObj[permission_data.at(0).toString()] = adminRoleObj;

            // Update the roles in the main JSON object
            jsonObj["roles"] = rolesObj;

            QFile file(CONFIG_FILE_PATH);

            // Write the updated JSON back to the file
            if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
                qWarning() << "Couldn't open file for writing.";
                return false;
            }
            file.resize(0);

            // Create a new JSON document with the updated object
            QJsonDocument newJsonDoc(jsonObj);
            file.write(newJsonDoc.toJson(QJsonDocument::Indented));
            file.close();

            configFileData = newJsonDoc.toJson(QJsonDocument::Indented);

            return true;  // Successfully modified and saved
        } else {
            qWarning() << "RoleID already exists in roles.";
        }
    } else {
        qWarning() << "'roles' section not found or is not an object.";
    }
    return false;
}

bool HandleOperations::deleteRoleConfigfile(QString roleid)
{
    // Parse the JSON data
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(configFileData, &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "Error parsing JSON: " << parseError.errorString();
        return false;
    }

    // Convert to QJsonObject
    QJsonObject jsonObj = jsonDoc.object();

    // Access the "roles" section
    if (jsonObj.contains("roles") && jsonObj["roles"].isObject()) {
        QJsonObject rolesObj = jsonObj["roles"].toObject();

        // Remove the key roleid (Admin role)
        if (rolesObj.contains(roleid)) {
            rolesObj.remove(roleid);

            // Update the roles in the main JSON object
            jsonObj["roles"] = rolesObj;

            QFile file(CONFIG_FILE_PATH);

            // Write the updated JSON back to the file
            if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
                qWarning() << "Couldn't open file for writing.";
                return false;
            }
            file.resize(0);
            // Create a new JSON document with the updated object
            QJsonDocument newJsonDoc(jsonObj);
            file.write(newJsonDoc.toJson(QJsonDocument::Indented));
            file.close();

            configFileData = newJsonDoc.toJson(QJsonDocument::Indented);

            return true;  // Successfully modified and saved
        } else {
            qWarning() << "RoleID not found in roles.";
        }
    } else {
        qWarning() << "'roles' section not found or is not an object.";
    }

    return false;
}

QStringList HandleOperations::getInitialRoles()
{
    return rolenames;
}

void HandleOperations::getPermissions(QString roleId)
{
    qDebug()<<"Get Permissions based on ROLE ID: "<<roleId;
    screenPerm.clear();
    screenPerm = rolePermissions.value(roleId);
    qDebug()<<"Value Returned: "<<screenPerm;
}

bool HandleOperations::eventFilter(QObject *obj, QEvent *ev)
{
    //qDebug()<<"EVENT DETECTED: "<<ev->type();
    if((ev->type() == QEvent::KeyPress) || (ev->type() == QEvent::MouseMove)){
        elapsedTime.restart();
    }
    return QObject::eventFilter(obj,ev);
}

void HandleOperations::inactivityTimeout()
{
    qDebug()<<"ELAPSED TIME: "<<elapsedTime.elapsed()<<" "<<intactInterval*60000;
    if(elapsedTime.elapsed() > intactInterval*60000){
        inactTimer.stop();
        elapsedTime.invalidate();
        emit userInactive();
    }
}

