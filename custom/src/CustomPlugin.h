/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 *   @brief Custom QGCCorePlugin Declaration
 *   @author Gus Grubba <gus@auterion.com>
 */

#pragma once

#include "QGCCorePlugin.h"
#include "QGCApplication.h"
#include "QGCOptions.h"
#include "QGCLoggingCategory.h"
#include "SettingsManager.h"

#include "HandleOperations.h"
#include "UserRoleModel.h"
#include "Database.h"
#include "RolePermissionModel.h"

#include <QTranslator>

class CustomOptions;
class CustomPlugin;
class CustomSettings;
//class CustomVehicleManager;

Q_DECLARE_LOGGING_CATEGORY(CustomLog)

// class CustomFlyViewOptions : public QGCFlyViewOptions
// {
// public:
//     CustomFlyViewOptions(CustomOptions* options, QObject* parent = nullptr);

//     // Overrides from CustomFlyViewOptions
//     bool                    showInstrumentPanel         (void) const final;
//     bool                    showMultiVehicleList        (void) const final;
// };
class CustomOptions : public QGCOptions
{
public:
    CustomOptions(CustomPlugin*, QObject* parent = nullptr);

    // Overrides from QGCOptions
    bool                    wifiReliableForCalibration  (void) const final;
    bool                    showFirmwareUpgrade         (void) const final;
    //QGCFlyViewOptions*      flyViewOptions(void) final;

private:
    //CustomFlyViewOptions* _flyViewOptions = nullptr;
};

// class CustomVehicleManager : public MultiVehicleManager
// {
//     Q_OBJECT
// public:
//     CustomVehicleManager(QGCApplication* app, QGCToolbox *toolbox);
//     ~CustomVehicleManager();

//     Q_INVOKABLE QVariantList storevechiledata(int cnt);

// };

class CustomPlugin : public QGCCorePlugin
{
    Q_OBJECT
public:
    CustomPlugin(QGCApplication* app, QGCToolbox *toolbox);
    ~CustomPlugin();

    // Overrides from QGCCorePlugin
    QVariantList&           settingsPages                   (void) final;
    QVariantList&           analyzePages                    (void) final;
    QGCOptions*             options                         (void) final;
    //QString                 brandImageIndoor                (void) const final;
    //QString                 brandImageOutdoor               (void) const final;
    bool                    overrideSettingsGroupVisibility (QString name) final;
    bool                    adjustSettingMetaData           (const QString& settingsGroup, FactMetaData& metaData) final;
    void                    paletteOverride                 (QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo) final;
    QQmlApplicationEngine*  createQmlApplicationEngine      (QObject* parent) final;

    // Overrides from QGCTool
    void                    setToolbox                      (QGCToolbox* toolbox);

private slots:
    void _advancedChanged(bool advanced);

private:
    void _addSettingsEntry(const QString& title, const char* qmlFile, const char* iconFile = nullptr);
    void _addAnalyzeToolsEntry(const QString& title, const char* qmlFile, const char* iconFile = nullptr);

    HandleOperations *opCls = HandleOperations::getInstance();
    UserRoleModel *userRoleMdl = UserRoleModel::getInstance();
    Database *gcsDb = Database::getInstance();
    RolePermissionModel *rolePermMdl = RolePermissionModel::getInstance();

private:
    CustomOptions*  _options = nullptr;
    //CustomVehicleManager* _customvehicle = nullptr;
    QVariantList    _customSettingsList; // Not to be mixed up with QGCCorePlugin implementation
    QVariantList    _customAnalyzeToolsList;
};
