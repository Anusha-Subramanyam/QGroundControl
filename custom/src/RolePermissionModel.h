#ifndef ROLEPERMISSIONMODEL_H
#define ROLEPERMISSIONMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QVariant>
#include <QHash>
#include <QList>
#include "global.h"

class RolePermissionModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit RolePermissionModel(QObject *parent = nullptr);

    static RolePermissionModel *getInstance(){
        if(!instance){
            instance = new RolePermissionModel();
        }
        return instance;
    }

    enum RoleData{
        RoleID = Qt::UserRole + 1,
        RoleName,
        RoleDescription,
        Permissions,
        EditRole
        //DeleteRole
    };

    QVector<ROLE_DETAILS> roleData;
    QVector<ROLE_DETAILS> mainData;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void addRoleData(const QString &id, const QString &name,const QString &descrip, const QJsonObject &perm);
    Q_INVOKABLE void deleteRoles(int index);
    Q_INVOKABLE QVariantMap getRoleData(int index);
    void clearTable();
    Q_INVOKABLE void filterModel(const QString &roleName);
    Q_INVOKABLE void resetModel();
    Q_INVOKABLE int roleExists(QString roleid);
    Q_INVOKABLE QString getRoleParameter(int ind, QString param);
    int16_t getModelIndex(QString roleid);

private:
    static RolePermissionModel *instance;
};

#endif // ROLEPERMISSIONMODEL_H
