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

    QObject::connect(roleModel,&UserRoleModel::currentSelectedRoleChanged,this,[=](QString user, QString role, QString usersince){
        getPermissions(role);
        db->currentUser = user;
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
    qDebug()<<"BEFORE: "<<intactInterval;
    intactInterval = db->getInactivityTimeout();
    qDebug()<<"AFTER: "<<intactInterval;
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
        //QMap<QString, QStringList> screenPerm;

        // for (const QString &screen : permission.keys()) {
        //     QJsonArray permissionsArray = permission.value(screen).toArray();
        //     QStringList permissions;

        //     qDebug()<<"Screen Permissions in JSON: "<<screen;

        //     for (const QJsonValue &permission : permissionsArray) {
        //         QString permissionString = permission.toString();
        //         if (permissionString == "*") {
        //             permissions << "*";  // Indicating full access to the screen
        //         } else {
        //             permissions << permissionString;
        //         }
        //         qDebug()<<screen<<" "<<permissionString;
        //     }
        //     //screenPerm.insert(screen, permissions);
        // }
        rolepermModel->addRoleData(roleId,roleName,roleDescription,permission);
        //rolePermissions.insert(roleId,screenPerm);
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

QStringList HandleOperations::getScreenNames()       //Not in use currently
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

void HandleOperations::userRegistration(QString user, QString pwd, int role)
{
    QString roleID = rolepermModel->getRoleData(role).value("roleid").toString();
    QString userSince = QDateTime::currentDateTime().toString("yyyyMMddhhmmss");
    roleModel->addData(user,pwd,0,roleID,userSince,"-");
    QString encyptPass = crypto->encryption(pwd);
    db->addUser(user,encyptPass,roleID,userSince);
}

void HandleOperations::handleInactiveChanged(int interval)
{
    if(inactTimer.isActive()){
        qDebug()<<"Inact Timer Stopped";
        inactTimer.stop();
    }
    intactInterval = interval;
    db->setInactivityTimeout(interval);
    inactTimer.start();
    elapsedTime.restart();
}

void HandleOperations::editUserData(int row, QString id, QString password, int role)
{
    QString roleID = rolepermModel->getRoleData(role).value("roleid").toString();
    db->editData(row,id,password,roleID);
    QModelIndex ind = roleModel->index(row-1,0);
    roleModel->setData(ind,id,UserRoleModel::UserID);
    roleModel->setData(ind,password,UserRoleModel::Password);
    roleModel->setData(ind,roleID,UserRoleModel::UserRole);
}

QString HandleOperations::getDateTime(QString input)
{
    QString result = "";
    QDateTime dateTime = QDateTime::fromString(input, "yyyyMMddhhmmss");
    result = dateTime.date().toString() + ", " +dateTime.time().toString();
    return result;
}

bool HandleOperations::addRoleConfigfile(QList<QVariant> permission_data, int index)
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
            permissionObj["Menu"] = QJsonArray(permission_data.at(3).toJsonArray());
            permissionObj["GCS"] = QJsonArray(permission_data.at(4).toJsonArray());
            qDebug()<<"................................................................";
            qDebug()<<permission_data.at(4).Size;
            // QVariant variant = permission_data.at(4);
            if(!permission_data.at(5).toList().isEmpty()){
                permissionObj["AnalyzeTools"] = QJsonArray(permission_data.at(5).toJsonArray());
            }
            if(!permission_data.at(6).toList().isEmpty()){
                permissionObj["AppSettings"] = QJsonArray(permission_data.at(6).toJsonArray());
            }

            adminRoleObj["permission"] = permissionObj;

            if(index != -1){
                QModelIndex ind = rolepermModel->index(index,0);
                rolepermModel->setData(ind, permission_data.at(0).toString(),RolePermissionModel::RoleID);
                rolepermModel->setData(ind, permission_data.at(1).toString(),RolePermissionModel::RoleName);
                rolepermModel->setData(ind, permission_data.at(2).toString(),RolePermissionModel::RoleDescription);
                rolepermModel->setData(ind, permissionObj,RolePermissionModel::Permissions);
            }else{
                rolepermModel->addRoleData(permission_data.at(0).toString(),permission_data.at(1).toString(), permission_data.at(2).toString(),permissionObj);
            }

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
    // screenPerm.clear();
    // screenPerm = rolePermissions.value(roleId);

    screenPerm.clear();
    int index = rolepermModel->getModelIndex(roleId);
    if(index != -1){
        QVariantMap data = rolepermModel->getRoleData(index);
        QJsonObject dataval = data.value("perm").toJsonObject();

        for (const QString &screen : dataval.keys()) {
            QJsonArray permissionsArray = dataval.value(screen).toArray();
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

    }

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

void HandleOperations::saveToFile(const QString &filePath,QString id)
{
    QFile file(filePath);
    QString fileExtension = QFileInfo(filePath).suffix();
    QVariant  datafromdb = db->readMissionHistory(id,true);
    // Extract the QVariantList from the QVariant
    QVariantList dataList = datafromdb.toList();
    QStringList extractedData = {};

    // Check if the list contains at least one element and that the first element is a QStringList
    if (!dataList.isEmpty() && dataList.first().canConvert<QStringList>()) {
        // Extract the QStringList from the first QVariant in the list
        extractedData = dataList.first().toStringList();

        // Now you can access each element in the QStringList as needed
         qDebug()<<"..................................................";
        qDebug() <<"extractedData"<< extractedData;
          qDebug()<<"..................................................";
    } else {
        qDebug() << "Data format is not as expected.";
    }


    QVariantList reportdata = {"1","Ardino","firmware","24hrs"};
    qDebug()<<"Report Data"<<reportdata;
    if (fileExtension == "json") {
        saveJsonToFile(file,extractedData);
    } else if (fileExtension == "csv") {
        saveCsvToFile(file,extractedData);
    } else if (fileExtension == "pdf") {
        // saveCsvToFile(file,reportdata);
        savePdfToFile(filePath,extractedData);
    } else {
        qDebug() << "Unsupported file format!";
    }
}

void HandleOperations::saveJsonToFile(QFile &file,QStringList reportdata)
{
    // Create a JSON object

    QJsonObject jsonObject;
    jsonObject["VehicleID"] = QJsonValue::fromVariant(reportdata[0]);
    jsonObject["VehicleType"] = QJsonValue::fromVariant(reportdata[1]);
    jsonObject["FirmwareType"] =QJsonValue::fromVariant(reportdata[2]);
    jsonObject["MissionID "] = QJsonValue::fromVariant(reportdata[3]);
    jsonObject["MissionTime"] = QJsonValue::fromVariant(reportdata[4]);
    jsonObject["MissionDistance"] = QJsonValue::fromVariant(reportdata[5]);
    jsonObject["Latitude"] = QJsonValue::fromVariant(reportdata[6]);
    jsonObject["Longitude"] = QJsonValue::fromVariant(reportdata[7]);
    jsonObject["Altitude"] = QJsonValue::fromVariant(reportdata[8]);
    jsonObject["NumberOfSatellites"] = QJsonValue::fromVariant(reportdata[9]);
    jsonObject["HDOP"] = QJsonValue::fromVariant(reportdata[10]);
    jsonObject["CompassHeading"] = QJsonValue::fromVariant(reportdata[11]);
    jsonObject["Airspeed"] = QJsonValue::fromVariant(reportdata[12]);
    jsonObject["GroundSpeed"] = QJsonValue::fromVariant(reportdata[13]);
    jsonObject["BatteryVoltage"] = QJsonValue::fromVariant(reportdata[14]);
    jsonObject["BatteryCurrentDraw"] = QJsonValue::fromVariant(reportdata[15]);
    jsonObject["RemainingBatteryPercentage"] = QJsonValue::fromVariant(reportdata[16]);
    jsonObject["BatteryTemperature"] = QJsonValue::fromVariant(reportdata[17]);
    jsonObject["HomePosition"] = QJsonValue::fromVariant(reportdata[18]);
    jsonObject["DistancefromHome"] = QJsonValue::fromVariant(reportdata[19]);
    jsonObject["WindDirection"] = QJsonValue::fromVariant(reportdata[20]);
    jsonObject["WindSpeed"] = QJsonValue::fromVariant(reportdata[21]);
    jsonObject["WindVerticalSpeed"] = QJsonValue::fromVariant(reportdata[22]);
    jsonObject["Temperature "] = QJsonValue::fromVariant(reportdata[23]);
    jsonObject["AbsoluteAltitude"] = QJsonValue::fromVariant(reportdata[24]);
    jsonObject["RelativeAltitude"] = QJsonValue::fromVariant(reportdata[25]);
    jsonObject["SignalStrength"] = QJsonValue::fromVariant(reportdata[26]);
    jsonObject["CurrentDateAndTime"] = QJsonValue::fromVariant(reportdata[27]);

    // Convert the JSON object to a string
    QJsonDocument jsonDoc(jsonObject);
    QString jsonString = jsonDoc.toJson(QJsonDocument::Indented);

    // Write JSON data to file
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << jsonString;
        file.close();
        qDebug() << "JSON data successfully written to: " << file.fileName();
    } else {
        qDebug() << "Failed to open or create JSON file for writing: " << file.fileName();
    }
}

void HandleOperations::saveCsvToFile(QFile &file,QStringList reportdata)
{

    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        // Write CSV header
        out << "VehicleID,VehicleType,FirmwareType,MissionID,MissionTime,MissionDistance,Latitude,Longitude,Altitude,NumberOfSatellites,HDOP,CompassHeading,Airspeed,GroundSpeed,BatteryVoltage,BatteryCurrentDraw,RemainingBatteryPercentage,BatteryTemperature,HomePosition,DistancefromHome,WindDirection,WindSpeed,WindVerticalSpeed,Temperature,AbsoluteAltitude,RelativeAltitude,SignalStrength,CurrentDateAndTime\n";
        out<<reportdata[0]+","+reportdata[1]+","+reportdata[2]+","+reportdata[3]+","+reportdata[4]+","+reportdata[5]+","+reportdata[6]+","+reportdata[7]+","+reportdata[8]+","+reportdata[9]+","+reportdata[10]+","+reportdata[11]+","+reportdata[12]+","+reportdata[13]+","+reportdata[14]+","+reportdata[15]+","+reportdata[16]+","+reportdata[17]+","+reportdata[18]+","+reportdata[19]+","+reportdata[20]+","+reportdata[21]+","+reportdata[22]+","+reportdata[23]+","+reportdata[24]+","+reportdata[25]+","+reportdata[26]+","+reportdata[27]+"\n";

        file.close();
        qDebug() << "CSV data successfully written to:" << file.fileName();
    } else {
        qWarning() << "Failed to open or create CSV file for writing:" << file.fileName();
    }
}

void HandleOperations::savePdfToFile(QString filepath,QStringList reportdata)
{
    // Ensure the file path is valid and use it to create a PDF writer
    QString filePath = filepath;
    if (filePath.isEmpty()) {
        qWarning() << "No file path provided!";
        return;
    }

    // Initialize QPdfWriter with the file path
    QPdfWriter pdfWriter(filePath);
    pdfWriter.setPageSize(QPageSize(QPageSize::A4));
    pdfWriter.setResolution(300);

    QPainter painter(&pdfWriter);
    if (!painter.isActive()) {
        qWarning() << "Could not initialize PDF painter!";
        return;
    }


    int yPosition = 100;
    const int lineSpacing = 50;
    painter.setFont(QFont("Arial", 12));

    painter.drawText(100, yPosition, "Report Data:");
    yPosition += lineSpacing;

    // for (const QVariant &data : reportdata) {
    //     painter.drawText(100, yPosition, data.toString());
    //     yPosition += lineSpacing;
    // }

    painter.end(); // Finalize the PDF document
    qDebug() << "PDF successfully created at:" << filePath;
}

void HandleOperations::writeDataToFile(const QStringList &dataList)
{


    QString filePath = "C:/QGCClone/QGroundControl/custom/Output.txt"; // Define your output file path here
    QFile file(filePath);

    // Open the file to read existing lines
    QStringList existingLines;

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            existingLines << in.readLine();
        }
        file.close();
    }



    // real data should be store in that mannar
    QString canInfo = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss")+
                      " VehicleID "+dataList[0]+
                      " VehicleType "+dataList[1]+
                      " FirmwareType "+dataList[2]+
                      " Latitude "+dataList[3]+
                      " Longitude "+dataList[4]+
                      " Altitude "+dataList[5]+
                      " NumberOfSatellites "+dataList[6]+
                      " HDOP "+dataList[7]+
                      " CompassHeading "+dataList[8]+
                      " Airspeed "+dataList[9]+
                      " GroundSpeed "+dataList[10]+
                      " BatteryVoltage "+dataList[11]+
                      " BatteryCurrentDraw "+dataList[12]+
                      " RemainingBatteryPercentage "+dataList[13]+
                      " BatteryTemperature "+dataList[14]+
                      " FlightMode "+dataList[15]+
                      " HomePosition "+dataList[16]+
                      " DistancefromHome "+dataList[17]+
                      " AbsoluteAltitude "+dataList[18]+
                      " RelativeAltitude "+dataList[19]+
                      " SignalStrength "+dataList[20]+
                      " CommunicationLoss "+dataList[21]+
                      " Gyro "+dataList[22]+
                      " Accelerometer "+dataList[23]+
                      " Magnetometer "+dataList[24]+
                      " Absolute pressure "+dataList[25]+
                      " Angular rate control "+dataList[26]+
                      " Attitude stabilization "+dataList[27]+
                      " Yaw position "+dataList[28]+
                      " Motor outputs /control "+dataList[29]+
                      " AHRS "+dataList[30]+
                      " Terrain "+dataList[31]+
                      " Battery "+dataList[32]+
                      " Propulsion "+dataList[33]+
                      " Z/altitude control "+dataList[34]+
                      " X/Y position control "+dataList[35]+
                      " GeoFence "+dataList[36]+
                      " Logging "+dataList[37]+
                      " Pre-Arm Check "+dataList[38];


    // Add the new data line
    qDebug()<<"before if condition.........................";
    // if(m_manager->activeVehicle()){
    // qDebug()<<".....................................";
    // qDebug()<<"Testing start.........................";
    // qDebug()<<m_manager->activeVehicle()->id();
    // qDebug()<<m_manager->activeVehicle()->vehicleType();
    // qDebug()<<m_manager->activeVehicle()->firmwareType();
    // qDebug()<<m_manager->activeVehicle()->latitude();
    // qDebug()<<m_manager->activeVehicle()->longitude();
    // qDebug()<<m_manager->activeVehicle()->altitudeAboveTerr();
    // qDebug()<<m_manager->activeVehicle()->altitudeAMSL();
    // qDebug()<<m_manager->activeVehicle()->;
    // qDebug()<<"Testing end.........................";
    // qDebug()<<".....................................";
    // }else{
    //     qDebug()<<"vehicle is not connected................";
    // }
    qDebug()<<"after if condition.........................";

    qDebug()<<"before inserting into the file.........................";
    QString dataLine = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss") + " - " + dataList.join(", ");
    existingLines.append(canInfo); // Add the new line to the end of the list

    // Check if we need to remove the oldest line
    qDebug()<<".......................................................";
    qDebug()<<".......................................................";
    qDebug()<<"line count"<<existingLines.size();
    qDebug()<<"line count"<<existingLines.count();
    qDebug()<<".......................................................";
    qDebug()<<".......................................................";
    while (existingLines.size() > 100) {
        existingLines.removeFirst(); // Remove the oldest line
    }

     qDebug()<<"before writing the file.........................";
    // Now write the updated lines back to the file
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        for (const QString& line : qAsConst(existingLines)) {
            out << line << "\n"; // Write each line back to the file
        }
        file.close();
    } else {
        qWarning() << "Unable to open file for writing.";
    }

}


