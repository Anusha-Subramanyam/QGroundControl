#include "UserRoleModel.h"
UserRoleModel *UserRoleModel::instance = nullptr;

UserRoleModel::UserRoleModel(QObject *parent)
    : QAbstractListModel{parent}
{}

int UserRoleModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return userData.count();
}

QVariant UserRoleModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid())
        return QVariant();

    const USER_DETAILS &user = userData[index.row()];

    switch(role){
    case UserID:
        return user.UserId;
    case Password:
        return user.Password;
    case ActiveStatus:
        return user.IsActive;
    case UserRole:
        return user.Role;
    case UserSince:
        return user.UserSince;
    case LastActive:
        return user.LastLogin;
    case EditUser:
        return user.EditUser;
    case DeleteUser:
        return user.DeleteUser;
    default:
        return QVariant();
    }
}

bool UserRoleModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    qDebug()<<"SETDATA IN USER MODEL "<<index<<" "<<index.row()<<value<<" "<<role;
    if (!index.isValid() || index.row() < 0 || index.row() >= userData.size())
        return false;

    USER_DETAILS &user = userData[index.row()];

    switch (role) {
    case UserID:
        user.UserId = value.toString();
        break;
    case Password:
        user.Password = value.toString();
        break;
    case ActiveStatus:
        user.IsActive = value.toString();
        break;
    case UserRole:
        user.Role = value.toString();
        break;
    case UserSince:
        user.UserSince = value.toString();
        break;
    case LastActive:
        user.LastLogin = value.toString();
        break;
    case EditUser:
        user.LastLogin = value.toString();
        break;
    case DeleteUser:
        user.DeleteUser = value.toString();
        break;
    default:
        return false;
    }
    mainData = userData;
    emit dataChanged(index, index, QVector<int>() << role);
    return true;
}

QHash<int, QByteArray> UserRoleModel::roleNames() const
{
    QHash<int, QByteArray> users;
    users[UserID] = "userid";
    users[Password] = "password";
    users[ActiveStatus] = "isactive";
    users[UserRole] = "role";
    users[UserSince] = "usersince";
    users[LastActive] = "lastlogin";
    users[EditUser] = "edituser";
    users[DeleteUser] = "deleteuser";
    return users;
}

void UserRoleModel::addData(const QString &id, const QString &pwd, const QString &active, const QString &userRole, const QString userSince, const QString lastLogin)
{
    beginInsertRows(QModelIndex(),rowCount(),rowCount());
    userData.append({id, pwd, active, userRole,userSince,lastLogin,"/custom/img/EditIcn.png","/custom/img/DeleteIcn.png"});
    mainData.append({id, pwd, active, userRole,userSince,lastLogin,"/custom/img/EditIcn.png","/custom/img/DeleteIcn.png"});
    // userPwdHash.insert(id, pwd);
    // userRoleHash.insert(id,userRole);
    endInsertRows();
}

void UserRoleModel::deleteData(int index)
{
    if (index < 0 || index >= userData.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    userData.removeAt(index);
    endRemoveRows();
}

QVariantMap UserRoleModel::getData(int index)
{
    QVariantMap result;
    if (index >= 0 && index < userData.size()) {
        const USER_DETAILS &user = userData.at(index);
        result["userid"] = user.UserId;
        result["password"] = user.Password;
        result["isactive"] = user.IsActive;
        result["role"] = user.Role;
        result["usersince"] = user.UserSince;
        result["lastlogin"] = user.LastLogin;
        result["edituser"] = user.EditUser;
        result["deleteuser"] = user.DeleteUser;
    }
    return result;
}

void UserRoleModel::clearTable()
{
    if(userData.isEmpty())
        return;

    beginRemoveRows(QModelIndex(), 0, userData.size() - 1);
    userData.clear();
    endRemoveRows();
}

bool UserRoleModel::searchUser(const QString &userID, const QString &pwd)
{
    bool loginSts = false;
    // for(int i=0;i<userData.size();i++){
    //     if(userData.at(i).UserId == userID){
    //         if(userData.at(i).Password == pwd){      //Decryption function to be used
    //             loginSts = true;
    //             break;
    //         }
    //     }
    // }
    int index = getModelIndex(userID);
    if(index != -1){
        QVariantMap data = getData(index);
        if(data.value("password").toString() == pwd){
            loginSts = true;
            QModelIndex ind = createIndex(index,0);
            setData(ind,"1",ActiveStatus);
            setData(ind,QDateTime::currentDateTime().toString("yyyyMMddhhmmss"),LastActive);
            setCurrentSelectedRole(data.value("role").toString());
            setCurrentSelectedUser(userID);
            emit currentSelectedRoleChanged(currentUser,currentRole,data.value("usersince").toString());
        }else{
            ;
        }
    }
    return loginSts;
}


void UserRoleModel::filterModel(const QString &userID)
{
    beginResetModel();

    // Clear the filtered data
    userData.clear();

    // Filter based on userID
    for (const USER_DETAILS &data : mainData) {
        if (data.UserId == userID) {
            userData.append(data);
        }
    }
    endResetModel();
}

void UserRoleModel::resetModel()
{
    beginResetModel();
    userData = mainData;
    endResetModel();
}

int UserRoleModel::userExists(QString userID)
{
    return getModelIndex(userID);
}

int16_t UserRoleModel::getModelIndex(QString userID)
{
    int row = -1;
    for (int i = 0; i < userData.size(); ++i) {
        if (userData[i].UserId == userID) {
            row = i; // Found the row
            break;
        }
    }
    return row;
}

QString UserRoleModel::getCurrentSelectedRole()
{
    return currentRole;
}

void UserRoleModel::setCurrentSelectedRole(QString role)
{
    currentRole = role;
}

QString UserRoleModel::getCurrentSelectedUser()
{
    return currentUser;
}

void UserRoleModel::setCurrentSelectedUser(QString user)
{
    currentUser = user;
}

