#include "RolePermissionModel.h"
RolePermissionModel *RolePermissionModel::instance = nullptr;

RolePermissionModel::RolePermissionModel(QObject *parent)
    : QAbstractListModel{parent}
{}

int RolePermissionModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return roleData.count();
}

QVariant RolePermissionModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid())
        return QVariant();

    const ROLE_DETAILS &roles = roleData[index.row()];

    switch(role){
    case RoleID:
        return roles.RoleId;
    case RoleName:
        return roles.RoleName;
    case RoleDescription:
        return roles.Description;
    case Permissions:
        return roles.Permissions;
    case EditRole:
        return roles.EditRole;
    // case DeleteRole:
    //     return roles.DeleteRole;
    default:
        return QVariant();
    }
}

bool RolePermissionModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() < 0 || index.row() >= roleData.size())
        return false;

    ROLE_DETAILS &roles = roleData[index.row()];

    switch (role) {
    case RoleID:
        roles.RoleId = value.toString();
        break;
    case RoleName:
        roles.RoleName = value.toString();
        break;
    case RoleDescription:
        roles.Description = value.toString();
        break;
    case Permissions:
        roles.Permissions = value.toJsonObject();
        break;
    case EditRole:
        roles.EditRole = value.toString();
        break;
    // case DeleteRole:
    //     roles.DeleteRole = value.toString();
    //     break;
    default:
        return false;
    }
    mainData = roleData;

    emit dataChanged(index, index, QVector<int>() << role);
    return true;
}

QHash<int, QByteArray> RolePermissionModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[RoleID] = "roleid";
    roles[RoleName] = "rolename";
    roles[RoleDescription] = "roledesp";
    roles[Permissions] = "perm";
    roles[EditRole] = "editrole";
    //roles[DeleteRole] = "deleterole";
    return roles;
}

void RolePermissionModel::addRoleData(const QString &id, const QString &name, const QString &descrip, const QJsonObject &perm)
{
    beginInsertRows(QModelIndex(),rowCount(),rowCount());
    roleData.append({id,name,descrip,perm,"/custom/img/EditIcn.png"/*,"/custom/img/DeleteIcn.svg"*/});
    mainData.append({id,name,descrip,perm,"/custom/img/EditIcn.png"/*,"/custom/img/DeleteIcn.svg"*/});
    endInsertRows();
}

void RolePermissionModel::deleteRoles(int index)
{
    if (index < 0 || index >= roleData.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    roleData.removeAt(index);
    endRemoveRows();
}

QVariantMap RolePermissionModel::getRoleData(int index)
{
    QVariantMap result;
    if (index >= 0 && index < roleData.size()) {
        const ROLE_DETAILS &roles = roleData.at(index);
        result["roleid"] = roles.RoleId;
        result["rolename"] = roles.RoleName;
        result["roledesp"] = roles.Description;
        result["perm"] = roles.Permissions;
        result["editrole"] = roles.EditRole;
        //result["deleterole"] = roles.DeleteRole;
    }
    return result;
}

void RolePermissionModel::clearTable()
{
    if(roleData.isEmpty())
        return;

    beginRemoveRows(QModelIndex(), 0, roleData.size() - 1);
    roleData.clear();
    endRemoveRows();
}

void RolePermissionModel::filterModel(const QString &roleName)
{
    beginResetModel();

    // Clear the filtered data
    roleData.clear();

    // Filter based on userID
    for (const ROLE_DETAILS &data : mainData) {
        if (data.RoleName ==roleName) {
            roleData.append(data);
        }
    }
    endResetModel();
}

void RolePermissionModel::resetModel()
{
    beginResetModel();
    roleData = mainData;
    endResetModel();
}

int RolePermissionModel::roleExists(QString roleid)
{
    return getModelIndex(roleid);
}

QString RolePermissionModel::getRoleParameter(int ind,QString param)
{
    return getRoleData(ind).value(param).toString();
}

int16_t RolePermissionModel::getModelIndex(QString roleid)
{
    int row = -1;
    for (int i = 0; i < roleData.size(); ++i) {
        if (roleData[i].RoleId == roleid) {
            row = i; // Found the row
            break;
        }
    }
    return row;
}


