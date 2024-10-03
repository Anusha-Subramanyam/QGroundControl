#ifndef USERROLEMODEL_H
#define USERROLEMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QVariant>
#include <QHash>
#include <QList>
#include "global.h"

class UserRoleModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString currentSelectedRole READ getCurrentSelectedRole WRITE setCurrentSelectedRole NOTIFY currentSelectedRoleChanged);
    Q_PROPERTY(QString currentSelectedUser READ getCurrentSelectedUser WRITE setCurrentSelectedUser NOTIFY currentSelectedUserChanged);

public:
    explicit UserRoleModel(QObject *parent = nullptr);

    static UserRoleModel *getInstance(){
        if(!instance){
            instance = new UserRoleModel();
        }
        return instance;
    }

    enum UserData{
        UserID = Qt::UserRole + 1,
        Password,
        ActiveStatus,
        UserRole,
        UserSince,
        LastActive,
        EditUser,
        DeleteUser
    };

    QVector<USER_DETAILS> userData;
    QVector<USER_DETAILS> mainData;

    // QHash<QString,QString> userPwdHash;
    // QHash<QString,QString> userRoleHash;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void addData(const QString &id, const QString &pwd,const QString &active, const QString &userRole, const QString userSince, const QString lastLogin);
    Q_INVOKABLE void deleteData(int index);
    Q_INVOKABLE QVariantMap getData(int index);
    void clearTable();
    Q_INVOKABLE bool searchUser(const QString &userID,const QString &pwd);
    Q_INVOKABLE void filterModel(const QString &userID);
    Q_INVOKABLE void resetModel();
    Q_INVOKABLE int userExists(QString userID);
    //Q_INVOKABLE int roleExists(QString roleID);
    int16_t getModelIndex(QString userID);

    Q_INVOKABLE QString getCurrentSelectedRole();
    void setCurrentSelectedRole(QString role);

    QString getCurrentSelectedUser();
    void setCurrentSelectedUser(QString user);

signals:
    void currentSelectedRoleChanged(QString roleId);
    void currentSelectedUserChanged();

private:
    static UserRoleModel *instance;
    QString currentRole = "";
    QString currentUser = "";
};

#endif // USERROLEMODEL_H
