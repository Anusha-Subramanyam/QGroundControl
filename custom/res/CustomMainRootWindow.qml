/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0

/// @brief Native QML top level window
/// All properties defined here are visible to all QML pages.
ApplicationWindow {
    id:             mainWindow
    //minimumWidth:   ScreenTools.isMobile ? Screen.width  : Math.min(ScreenTools.defaultFontPixelWidth * 100, Screen.width)
    //minimumHeight:  ScreenTools.isMobile ? Screen.height : Math.min(ScreenTools.defaultFontPixelWidth * 50, Screen.height)
    visible:        true
    minimumWidth: Screen.width
    minimumHeight: Screen.height

    Component.onCompleted: {
        //-- Full screen on mobile or tiny screens
        if (ScreenTools.isMobile || Screen.height / ScreenTools.realPixelDensity < 120) {
            mainWindow.showFullScreen()
        } else {
            width   = ScreenTools.isMobile ? Screen.width  : Math.min(250 * Screen.pixelDensity, Screen.width)
            height  = ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)
        }

        // Start the sequence of first run prompt(s)
        firstRunPromptManager.nextPrompt()
    }

    Connections{
        target: opCls

        function onUserInactive(){
            mainWindow.showMessageDialog(closeDialogTitle,
                                         qsTr("Inactive for a long time. Logging out..."),
                                         StandardButton.Ok,
                                         function() {
                                             logoutFlag = true
                                             checkForUnsavedMission()
                                         })
        }
    }

    QtObject {
        id: firstRunPromptManager

        property var currentDialog:     null
        property var rgPromptIds:       QGroundControl.corePlugin.firstRunPromptsToShow()
        property int nextPromptIdIndex: 0

        function clearNextPromptSignal() {
            if (currentDialog) {
                currentDialog.closed.disconnect(nextPrompt)
            }
        }

        function nextPrompt() {
            if (nextPromptIdIndex < rgPromptIds.length) {
                var component = Qt.createComponent(QGroundControl.corePlugin.firstRunPromptResource(rgPromptIds[nextPromptIdIndex]));
                currentDialog = component.createObject(mainWindow)
                currentDialog.closed.connect(nextPrompt)
                currentDialog.open()
                nextPromptIdIndex++
            } else {
                currentDialog = null
                showPreFlightChecklistIfNeeded()
            }
        }
    }

    property var                _rgPreventViewSwitch:       [ false ]

    readonly property real      _topBottomMargins:          ScreenTools.defaultFontPixelHeight * 0.5

    //Added by DST
    property bool logoutFlag: false
    property bool manageUserVis: false
    property bool vehSetupVis: false
    property bool analyzetoolsVis: false
    property bool appSettVis: false
    property bool showLogDownload: false
    property bool showGeoTag: false
    property bool showMavConsole: false
    property bool showMavInsp: false
    property bool showVibration: false
    property bool showactivityLogs: false

    property bool showgenTab: false
    property bool showCommLink: false
    property bool showOffMap: false
    property bool showMavlink: false
    property bool showRemoteID: false
    property bool showConsole: false
    property bool showHelp: false
    property bool showMockLink: false
    property bool showDebug: false
    property bool showPalette: false

    //-------------------------------------------------------------------------
    //-- Global Scope Variables

    QtObject {
        id: globals

        readonly property var       activeVehicle:                  QGroundControl.multiVehicleManager.activeVehicle
        readonly property real      defaultTextHeight:              ScreenTools.defaultFontPixelHeight
        readonly property real      defaultTextWidth:               ScreenTools.defaultFontPixelWidth
        readonly property var       planMasterControllerFlyView:    flightView.planController
        readonly property var       guidedControllerFlyView:        flightView.guidedController

        property var                planMasterControllerPlanView:   null
        property var                currentPlanMissionItem:         planMasterControllerPlanView ? planMasterControllerPlanView.missionController.currentPlanViewItem : null

        // Property to manage RemoteID quick acces to settings page
        property bool               commingFromRIDIndicator:        false
    }

    /// Default color palette used throughout the UI
    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    //-------------------------------------------------------------------------
    //-- Actions

    signal armVehicleRequest
    signal forceArmVehicleRequest
    signal disarmVehicleRequest
    signal vtolTransitionToFwdFlightRequest
    signal vtolTransitionToMRFlightRequest
    signal showPreFlightChecklistIfNeeded

    //-------------------------------------------------------------------------
    //-- Global Scope Functions

    //Added by DST
    function setScreenPermissions(screen){
        var screens = opCls.getScreenNames()
        var permissions = opCls.getPermListBasedonScreen(screen)
        console.log("SCREENS: ",screens);
        console.log("PERMISSION: ",permissions);
        switch(screen){
        case "FlyView":
            flightView._widgetLayer.rightToolStrip.flyViewToolStripActionList.planButton.visible = (permissions.indexOf("Planning") !== -1) ? true : false
            flightView._widgetLayer.instrumentPanel.visible = (permissions.indexOf("Telemetry") !== -1) ? true : false
            flightView._widgetLayer.rightToolStrip.flyViewToolStripActionList.dashboardButton.visible = (permissions.indexOf("Dashboard") !== -1) ? true : false
            break;
        case "Menu":
            vehSetupVis = (permissions.indexOf("VehicleSetup") !== -1) ? true : false
            analyzetoolsVis = (permissions.indexOf("AnalyzeTools") !== -1) ? true : false
            appSettVis = (permissions.indexOf("AppSettings") !== -1) ? true : false
            manageUserVis = (permissions.indexOf("ManageUsers") !== -1) ? true : false
            break;
        case "AnalyzeTools":
            showLogDownload = (permissions.indexOf("LogDownLoad") !== -1) ? true : false
            showGeoTag = (permissions.indexOf("GeoTag") !== -1) ? true : false
            showMavConsole = (permissions.indexOf("MavConsole") !== -1) ? true : false
            showMavInsp = (permissions.indexOf("MavInsp") !== -1) ? true : false
            showVibration = (permissions.indexOf("Vibration") !== -1) ? true : false
            showactivityLogs = (permissions.indexOf("ActivityLogs") !== -1) ? true : false
            break;
        case "AppSettings":
            showgenTab = (permissions.indexOf("General") !== -1) ? true : false
            showCommLink = (permissions.indexOf("CommLinks") !== -1) ? true : false
            showOffMap = (permissions.indexOf("OfflineMaps") !== -1) ? true : false
            showMavlink = (permissions.indexOf("MavLink") !== -1) ? true : false
            showRemoteID = (permissions.indexOf("RemoteID") !== -1) ? true : false
            showConsole = (permissions.indexOf("Console") !== -1) ? true : false
            showHelp = (permissions.indexOf("Help") !== -1) ? true : false
            showMockLink = (permissions.indexOf("MockLink") !== -1) ? true : false
            showDebug = (permissions.indexOf("Debug") !== -1) ? true : false
            showPalette = (permissions.indexOf("PaletteTest") !== -1) ? true : false
        default:
            break;
        }
        // else if(screen == "Vehicle Setup"){
        //     if(permissions.indexOf("Firmware") != -1){
        //         toolDrawer.hideComponentInSetupView("firmwareButton",true)
        //     }else{
        //         toolDrawer.hideComponentInSetupView("firmwareButton",false)
        //     }
        // }
        // if(permissions.indexOf("Dashboard") != -1){
        //     setupButton.visible = true
        // }else{
        //     setupButton.visible = false
        // }
        // if(permissions.indexOf("Telemetry") != -1){
        //     flightView._widgetLayer.instrumentPanel.visible = true
        // }else{
        //     flightView._widgetLayer.instrumentPanel.visible = false
        // }

        // if(permissions.indexOf("Toolbar") != -1){
        //     toolbar.visible = true
        //     toolbar.opacity = 1
        //     toolbar.enabled = true
        // }else{
        //     toolbar.visible = false
        // }
    }

    /// Prevent view switching
    function pushPreventViewSwitch() {
        _rgPreventViewSwitch.push(true)
    }

    /// Allow view switching
    function popPreventViewSwitch() {
        if (_rgPreventViewSwitch.length == 1) {
            console.warn("mainWindow.popPreventViewSwitch called when nothing pushed")
            return
        }
        _rgPreventViewSwitch.pop()
    }

    /// @return true: View switches are not currently allowed
    function preventViewSwitch() {
        return _rgPreventViewSwitch[_rgPreventViewSwitch.length - 1]
    }

    function viewSwitch(currentToolbar) {
        toolDrawer.visible      = false
        toolDrawer.toolSource   = ""
        flightView.visible      = false
        planView.visible        = false
        toolbar.currentToolbar  = currentToolbar
    }

    function showFlyView() {
        if (!flightView.visible) {
            mainWindow.showPreFlightChecklistIfNeeded()
        }
        viewSwitch(toolbar.flyViewToolbar)
        flightView.visible = true
        dashboard.visible = false
        dashboard.enabled = false
    }

    function showPlanView() {
        viewSwitch(toolbar.planViewToolbar)
        planView.visible = true
    }

    function showDashboardView(){
        dashboard.visible = true
        dashboard.enabled = true
        flightView.visible = false
        planView.visible = false
        toolbar.visible = false
    }

    function showTool(toolTitle, toolSource, toolIcon) {
        toolDrawer.backIcon     = flightView.visible ? "/qmlimages/PaperPlane.svg" : "/qmlimages/Plan.svg"
        toolDrawer.toolTitle    = toolTitle
        toolDrawer.toolSource   = toolSource
        toolDrawer.toolIcon     = toolIcon
        toolDrawer.visible      = true
    }

    function showAnalyzeTool() {
        showTool(qsTr("Analyze Tools"), "AnalyzeView.qml", "/qmlimages/Analyze.svg")
    }

    function showSetupTool() {
        showTool(qsTr("Vehicle Setup"), "SetupView.qml", "/qmlimages/Gears.svg")
    }

    function showSettingsTool() {
        showTool(qsTr("Application Settings"), "AppSettings.qml", "/res/QGCLogoWhite")
    }

    //-------------------------------------------------------------------------
    //-- Global simple message dialog

    function showMessageDialog(dialogTitle, dialogText, buttons = StandardButton.Ok, acceptFunction = null) {
        simpleMessageDialogComponent.createObject(mainWindow, { title: dialogTitle, text: dialogText, buttons: buttons, acceptFunction: acceptFunction }).open()
    }

    // This variant is only meant to be called by QGCApplication
    function _showMessageDialog(dialogTitle, dialogText) {
        showMessageDialog(dialogTitle, dialogText)
    }

    Component {
        id: simpleMessageDialogComponent

        QGCSimpleMessageDialog {
        }
    }

    /// Saves main window position and size
    MainWindowSavedState {
        window: mainWindow
    }

    property bool _forceClose: false

    function finishCloseProcess() {
        _forceClose = true
        // For some reason on the Qml side Qt doesn't automatically disconnect a signal when an object is destroyed.
        // So we have to do it ourselves otherwise the signal flows through on app shutdown to an object which no longer exists.
        firstRunPromptManager.clearNextPromptSignal()
        QGroundControl.linkManager.shutdown()
        QGroundControl.videoManager.stopVideo();
        //mainWindow.close()
        //Added by DST
        opCls.handleManualLogout();

        //Added by DST
        if(logoutFlag == true){
            userlogin.visible = true
            userlogin.enabled = true
            userlogin.userid = ""
            userlogin.password = ""
            userlogin.errortxt = ""
            userlogin.passwordHide = true
            flightView.visible = false
            manageusers.visible = false
            manageusers.enabled = false
            planView.visible = false
            toolbar.visible = false
            toolDrawer.visible = false
            //toolSelectDialogComponent.visible = false
            logoutFlag = false
        }else{
            mainWindow.close()
        }
        //
    }

    // On attempting an application close we check for:
    //  Unsaved missions - then
    //  Pending parameter writes - then
    //  Active connections

    property string closeDialogTitle: qsTr("Close %1").arg(QGroundControl.appName)

    function checkForUnsavedMission() {
        if (globals.planMasterControllerPlanView && globals.planMasterControllerPlanView.dirty) {
            showMessageDialog(closeDialogTitle,
                              qsTr("You have a mission edit in progress which has not been saved/sent. If you close you will lose changes. Are you sure you want to close?"),
                              StandardButton.Yes | StandardButton.No,
                              function() { checkForPendingParameterWrites() })
        } else {
            checkForPendingParameterWrites()
        }
    }

    function checkForPendingParameterWrites() {
        for (var index=0; index<QGroundControl.multiVehicleManager.vehicles.count; index++) {
            if (QGroundControl.multiVehicleManager.vehicles.get(index).parameterManager.pendingWrites) {
                mainWindow.showMessageDialog(closeDialogTitle,
                                             qsTr("You have pending parameter updates to a vehicle. If you close you will lose changes. Are you sure you want to close?"),
                                             StandardButton.Yes | StandardButton.No,
                                             function() { checkForActiveConnections() })
                return
            }
        }
        checkForActiveConnections()
    }

    function checkForActiveConnections() {
        if (QGroundControl.multiVehicleManager.activeVehicle) {
            mainWindow.showMessageDialog(closeDialogTitle,
                                         qsTr("There are still active connections to vehicles. Are you sure you want to exit?"),
                                         StandardButton.Yes | StandardButton.No,
                                         function() { finishCloseProcess() })
        } else {
            finishCloseProcess()
        }
    }

    onClosing: {
        if (!_forceClose) {
            close.accepted = false
            checkForUnsavedMission()
        }else{
            //Added by DST
            opCls.handleManualLogout();
        }
    }

    //-------------------------------------------------------------------------
    /// Main, full window background (Fly View)
    background: Item {
        id:             rootBackground
        anchors.fill:   parent
    }


    //-------------------------------------------------------------------------
    /// Toolbar
    header: MainToolBar {
        id:         toolbar
        height:     ScreenTools.toolbarHeight
        visible:    (!(QGroundControl.videoManager.fullScreen && flightView.visible)) && (!userlogin.visible)

        logoutmousearea.onClicked:{
            if (!mainWindow.preventViewSwitch()) {
                mainWindow.showMessageDialog(closeDialogTitle,
                                             qsTr("Are you sure you want to Logout?"),
                                             StandardButton.Yes | StandardButton.No,
                                             function() {
                                                 logoutFlag = true
                                                 checkForUnsavedMission()
                                             })
            }
        }
    }

    footer: LogReplayStatusBar {
        visible: false//QGroundControl.settingsManager.flyViewSettings.showLogReplayStatusBar.rawValue
    }

    function showToolSelectDialog() {
        if (!mainWindow.preventViewSwitch()) {
            setScreenPermissions("Menu");
            toolSelectDialogComponent.createObject(mainWindow).open()

        }
    }

    Component {
        id: toolSelectDialogComponent

        // function closeToolBox(){
        //     toolSelectDialogComponent.toolSelectDialog.close();
        // }

        QGCPopupDialog {
            id:         toolSelectDialog
            title:      qsTr("Select Tool")
            buttons:    StandardButton.Close


            property real _toolButtonHeight:    ScreenTools.defaultFontPixelHeight * 3
            property real _margins:             ScreenTools.defaultFontPixelWidth


            ColumnLayout {
                width:  innerLayout.width + (toolSelectDialog._margins * 2)
                height: innerLayout.height + (toolSelectDialog._margins * 2)

                ColumnLayout {
                    id:             innerLayout
                    Layout.margins: toolSelectDialog._margins
                    spacing:        ScreenTools.defaultFontPixelWidth

                    SubMenuButton {
                        id:                 setupButton
                        height:             toolSelectDialog._toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Vehicle Setup")
                        imageColor:         qgcPal.text
                        imageResource:      "/qmlimages/Gears.svg"
                        visible:            vehSetupVis
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.close()
                                mainWindow.showSetupTool()
                            }
                        }
                    }

                    SubMenuButton {
                        id:                 analyzeButton
                        height:             toolSelectDialog._toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Analyze Tools")
                        imageResource:      "/qmlimages/Analyze.svg"
                        imageColor:         qgcPal.text
                        visible:            analyzetoolsVis && QGroundControl.corePlugin.showAdvancedUI
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.close()
                                setScreenPermissions("AnalyzeTools")
                                mainWindow.showAnalyzeTool()

                            }
                        }
                    }

                    SubMenuButton {
                        id:                 settingsButton
                        height:             toolSelectDialog._toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Application Settings")
                        imageResource:      "/res/QGCLogoFull"
                        imageColor:         "transparent"
                        visible:            appSettVis && !QGroundControl.corePlugin.options.combineSettingsAndSetup
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.close()
                                setScreenPermissions("AppSettings")
                                mainWindow.showSettingsTool()
                            }
                        }
                    }

                    //Added by DST

                    SubMenuButton {
                        id:                 manageuser
                        height:             toolSelectDialog._toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Manage Users")
                        imageResource:      "/custom/img/logout.png"
                        imageColor:         qgcPal.text
                        visible:            manageUserVis
                        onClicked: {
                            manageusers.txt1.font.bold = true
                            manageusers.txt2.font.bold = false
                            manageusers.txt3.font.bold = false
                            manageusers.userDataRect.border.color = "lightgrey"
                            manageusers.userRolePermRect.border.color = qgcPal.windowShadeDark
                            manageusers.userInactRect.border.color = qgcPal.windowShadeDark

                            manageusers.userdetails.visible = true
                            manageusers.userdetails.enabled = true
                            manageusers.userroleperm.visible = false
                            manageusers.userroleperm.enabled = false
                            manageusers.userinactivity.visible = false
                            manageusers.userinactivity.enabled = false

                            manageusers.visible = true
                            manageusers.enabled = true
                            flightView.visible = false
                            toolbar.visible = false
                            toolSelectDialog.close()
                        }
                    }
                    //

                    ColumnLayout {
                        width:                  innerLayout.width
                        spacing:                0
                        Layout.alignment:       Qt.AlignHCenter

                        QGCLabel {
                            id:                     versionLabel
                            text:                   qsTr("%1 Version").arg(QGroundControl.appName)
                            font.pointSize:         ScreenTools.smallFontPointSize
                            wrapMode:               QGCLabel.WordWrap
                            Layout.maximumWidth:    parent.width
                            Layout.alignment:       Qt.AlignHCenter
                        }

                        QGCLabel {
                            text:                   QGroundControl.qgcVersion
                            font.pointSize:         ScreenTools.smallFontPointSize
                            wrapMode:               QGCLabel.WrapAnywhere
                            Layout.maximumWidth:    parent.width
                            Layout.alignment:       Qt.AlignHCenter

                            QGCMouseArea {
                                id:                 easterEggMouseArea
                                anchors.topMargin:  -versionLabel.height
                                anchors.fill:       parent

                                onClicked: {
                                    if (mouse.modifiers & Qt.ControlModifier) {
                                        QGroundControl.corePlugin.showTouchAreas = !QGroundControl.corePlugin.showTouchAreas
                                        showTouchAreasNotification.open()
                                    } else if (ScreenTools.isMobile || mouse.modifiers & Qt.ShiftModifier) {
                                        if(!QGroundControl.corePlugin.showAdvancedUI) {
                                            advancedModeOnConfirmation.open()
                                        } else {
                                            advancedModeOffConfirmation.open()
                                        }
                                    }
                                }

                                // This allows you to change this on mobile
                                onPressAndHold: {
                                    QGroundControl.corePlugin.showTouchAreas = !QGroundControl.corePlugin.showTouchAreas
                                    showTouchAreasNotification.open()
                                }

                                MessageDialog {
                                    id:                 showTouchAreasNotification
                                    title:              qsTr("Debug Touch Areas")
                                    text:               qsTr("Touch Area display toggled")
                                    standardButtons:    StandardButton.Ok
                                }

                                MessageDialog {
                                    id:                 advancedModeOnConfirmation
                                    title:              qsTr("Advanced Mode")
                                    text:               QGroundControl.corePlugin.showAdvancedUIMessage
                                    standardButtons:    StandardButton.Yes | StandardButton.No
                                    onYes: {
                                        QGroundControl.corePlugin.showAdvancedUI = true
                                        advancedModeOnConfirmation.close()
                                    }
                                }

                                MessageDialog {
                                    id:                 advancedModeOffConfirmation
                                    title:              qsTr("Advanced Mode")
                                    text:               qsTr("Turn off Advanced Mode?")
                                    standardButtons:    StandardButton.Yes | StandardButton.No
                                    onYes: {
                                        QGroundControl.corePlugin.showAdvancedUI = false
                                        advancedModeOffConfirmation.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    FlyView {
        id:             flightView
        anchors.fill:   parent
        visible: false
    }

    PlanView {
        id:             planView
        anchors.fill:   parent
        visible:        false
    }

    Drawer {
        id:             toolDrawer
        width:          mainWindow.width
        height:         mainWindow.height
        edge:           Qt.LeftEdge
        dragMargin:     0
        closePolicy:    Drawer.NoAutoClose
        interactive:    false
        visible:        false

        property alias backIcon:    backIcon.source
        property alias toolTitle:   toolbarDrawerText.text
        property alias toolSource:  toolDrawerLoader.source
        property alias toolIcon:    toolIcon.source

        // Unload the loader only after closed, otherwise we will see a "blank" loader in the meantime
        onClosed: {
            toolDrawer.toolSource = ""
        }

        Rectangle {
            id:             toolDrawerToolbar
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.top:    parent.top
            height:         ScreenTools.toolbarHeight
            color:          qgcPal.toolbarBackground

            RowLayout {
                anchors.leftMargin: ScreenTools.defaultFontPixelWidth
                anchors.left:       parent.left
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    id:                     backIcon
                    width:                  ScreenTools.defaultFontPixelHeight * 2
                    height:                 ScreenTools.defaultFontPixelHeight * 2
                    fillMode:               Image.PreserveAspectFit
                    mipmap:                 true
                    color:                  qgcPal.text
                }

                QGCLabel {
                    id:     backTextLabel
                    text:   qsTr("Back")
                }

                QGCLabel {
                    font.pointSize: ScreenTools.largeFontPointSize
                    text:           "<"
                }

                QGCColoredImage {
                    id:                     toolIcon
                    width:                  ScreenTools.defaultFontPixelHeight * 2
                    height:                 ScreenTools.defaultFontPixelHeight * 2
                    fillMode:               Image.PreserveAspectFit
                    mipmap:                 true
                    color:                  qgcPal.text
                }

                QGCLabel {
                    id:             toolbarDrawerText
                    font.pointSize: ScreenTools.largeFontPointSize
                }
            }

            QGCMouseArea {
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                x:                  parent.mapFromItem(backIcon, backIcon.x, backIcon.y).x
                width:              (backTextLabel.x + backTextLabel.width) - backIcon.x
                onClicked: {
                    toolDrawer.visible      = false
                }
            }
        }

        Loader {
            id:             toolDrawerLoader
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.top:    toolDrawerToolbar.bottom
            anchors.bottom: parent.bottom

            Connections {
                target:                 toolDrawerLoader.item
                ignoreUnknownSignals:   true
                onPopout:               toolDrawer.visible = false
            }
        }

        //Added by DST
        // function hideComponentInAnalyseView(componentId,state) {
        //     if (toolDrawerLoader.item) {
        //         let component = toolDrawerLoader.item;
        //         if (component && component[componentId]) {
        //             console.log("Component exists")
        //             component[componentId] = state
        //         }else{
        //             console.log("Component does not exist")
        //         }
        //     }
        // }
    }

    //Added by DST
    ManageUserAcc{
        id: manageusers
        anchors.fill: parent
        visible: false

        bckbuttonmousearea.onClicked: {
            manageusers.visible = false
            manageusers.enabled = false
            flightView.visible = true
            toolbar.visible = true
        }

        Component.onCompleted: {
            console.log("Emitteddddd")
            var roles = opCls.getInitialRoles()
            if(roles.length != 0){
                console.log("Length: "<<roles.length)
                for(var i=0;i<roles.length;i++){
                    console.log("Data: "<<i<<roles[i])
                    userdetails.userrolemodel.combobox.model.append({text:roles[i]})
                }
            }

        }
    }

    //-------------------------------------------------------------------------
    //-- Critical Vehicle Message Popup

    function showCriticalVehicleMessage(message) {
        indicatorPopup.close()
        if (criticalVehicleMessagePopup.visible || QGroundControl.videoManager.fullScreen) {
            // We received additional wanring message while an older warning message was still displayed.
            // When the user close the older one drop the message indicator tool so they can see the rest of them.
            criticalVehicleMessagePopup.dropMessageIndicatorOnClose = true
        } else {
            criticalVehicleMessagePopup.criticalVehicleMessage      = message
            criticalVehicleMessagePopup.dropMessageIndicatorOnClose = false
            criticalVehicleMessagePopup.open()
        }
    }

    Popup {
        id:                 criticalVehicleMessagePopup
        y:                  ScreenTools.defaultFontPixelHeight
        x:                  Math.round((mainWindow.width - width) * 0.5)
        width:              mainWindow.width  * 0.55
        height:             criticalVehicleMessageText.contentHeight + ScreenTools.defaultFontPixelHeight * 2
        modal:              false
        focus:              true
        closePolicy:        Popup.CloseOnEscape

        property alias  criticalVehicleMessage:        criticalVehicleMessageText.text
        property bool   dropMessageIndicatorOnClose:   false

        background: Rectangle {
            anchors.fill:   parent
            color:          qgcPal.alertBackground
            radius:         ScreenTools.defaultFontPixelHeight * 0.5
            border.color:   qgcPal.alertBorder
            border.width:   2

            Rectangle {
                anchors.horizontalCenter:   parent.horizontalCenter
                anchors.top:                parent.top
                anchors.topMargin:          -(height / 2)
                color:                      qgcPal.alertBackground
                radius:                     ScreenTools.defaultFontPixelHeight * 0.25
                border.color:               qgcPal.alertBorder
                border.width:               1
                width:                      vehicleWarningLabel.contentWidth + _margins
                height:                     vehicleWarningLabel.contentHeight + _margins

                property real _margins: ScreenTools.defaultFontPixelHeight * 0.25

                QGCLabel {
                    id:                 vehicleWarningLabel
                    anchors.centerIn:   parent
                    text:               qsTr("Vehicle Error")
                    font.pointSize:     ScreenTools.smallFontPointSize
                    color:              qgcPal.alertText
                }
            }

            Rectangle {
                id:                         additionalErrorsIndicator
                anchors.horizontalCenter:   parent.horizontalCenter
                anchors.bottom:             parent.bottom
                anchors.bottomMargin:       -(height / 2)
                color:                      qgcPal.alertBackground
                radius:                     ScreenTools.defaultFontPixelHeight * 0.25
                border.color:               qgcPal.alertBorder
                border.width:               1
                width:                      additionalErrorsLabel.contentWidth + _margins
                height:                     additionalErrorsLabel.contentHeight + _margins
                visible:                    criticalVehicleMessagePopup.dropMessageIndicatorOnClose

                property real _margins: ScreenTools.defaultFontPixelHeight * 0.25

                QGCLabel {
                    id:                 additionalErrorsLabel
                    anchors.centerIn:   parent
                    text:               qsTr("Additional errors received")
                    font.pointSize:     ScreenTools.smallFontPointSize
                    color:              qgcPal.alertText
                }
            }
        }

        QGCLabel {
            id:                 criticalVehicleMessageText
            width:              criticalVehicleMessagePopup.width - ScreenTools.defaultFontPixelHeight
            anchors.centerIn:   parent
            wrapMode:           Text.WordWrap
            color:              qgcPal.alertText
            textFormat:         TextEdit.RichText
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                criticalVehicleMessagePopup.close()
                if (criticalVehicleMessagePopup.dropMessageIndicatorOnClose) {
                    criticalVehicleMessagePopup.dropMessageIndicatorOnClose = false;
                    QGroundControl.multiVehicleManager.activeVehicle.resetErrorLevelMessages();
                    toolbar.dropMessageIndicatorTool();
                }
            }
        }
    }

    //-------------------------------------------------------------------------
    //-- Indicator Popups

    function showIndicatorPopup(item, dropItem, dim = true) {
        indicatorPopup.currentIndicator = dropItem
        indicatorPopup.currentItem = item
        indicatorPopup.dim = dim
        indicatorPopup.open()
    }

    function hideIndicatorPopup() {
        indicatorPopup.close()
        indicatorPopup.currentItem = null
        indicatorPopup.currentIndicator = null
    }

    Popup {
        id:             indicatorPopup
        padding:        ScreenTools.defaultFontPixelWidth * 0.75
        modal:          true
        focus:          true
        dim:            false
        closePolicy:    Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property var    currentItem:        null
        property var    currentIndicator:   null
        background: Rectangle {
            width:  loader.width
            height: loader.height
            color:  Qt.rgba(0,0,0,0)
        }
        Loader {
            id:             loader
            onLoaded: {
                var centerX = mainWindow.contentItem.mapFromItem(indicatorPopup.currentItem, 0, 0).x - (loader.width * 0.5)
                if((centerX + indicatorPopup.width) > (mainWindow.width - ScreenTools.defaultFontPixelWidth)) {
                    centerX = mainWindow.width - indicatorPopup.width - ScreenTools.defaultFontPixelWidth
                }
                indicatorPopup.x = centerX
            }
        }
        onOpened: {
            loader.sourceComponent = indicatorPopup.currentIndicator
        }
        onClosed: {
            loader.sourceComponent = null
            indicatorPopup.currentIndicator = null
        }
    }

    // We have to create the popup windows for the Analyze pages here so that the creation context is rooted
    // to mainWindow. Otherwise if they are rooted to the AnalyzeView itself they will die when the analyze viewSwitch
    // closes.

    function createrWindowedAnalyzePage(title, source) {
        var windowedPage = windowedAnalyzePage.createObject(mainWindow)
        windowedPage.title = title
        windowedPage.source = source
    }

    Component {
        id: windowedAnalyzePage

        Window {
            width:      ScreenTools.defaultFontPixelWidth  * 100
            height:     ScreenTools.defaultFontPixelHeight * 40
            visible:    true

            property alias source: loader.source

            Rectangle {
                color:          QGroundControl.globalPalette.window
                anchors.fill:   parent

                Loader {
                    id:             loader
                    anchors.fill:   parent
                    onLoaded:       item.popped = true
                }
            }

            onClosing: {
                visible = false
                source = ""
            }
        }
    }

    //-------------------------------------------------------------------------
    /// DashBoard

    Dashboard{
        id: dashboard
        anchors.fill: parent
        visible: false
        enabled: false

        bckbuttonmousearea.onClicked: {
            showFlyView();
            toolbar.visible = true
        }
    }

    //-------------------------------------------------------------------------
    /// User Login

    UserLogin {
        id: userlogin
        anchors.fill: parent
        visible: true
        enabled: true

        loginbuttonmousearea.onClicked: {
            if(userid != "" && password != ""){
                if(roleModel.searchUser(userid,password)){
                    setScreenPermissions("FlyView");
                    opCls.setSessionID(userid);
                    showFlyView();
                    toolbar.visible = true

                    // toolbar.visible = true
                    // flightView.visible = true
                    //planView.visible = false
                    userlogin.visible = false
                    userlogin.enabled = false
                    qgcApplication._initStart();

                }else{
                    errortxt = "Invalid Credentials !"
                }
            }else{
                errortxt = "User ID/Password cannot be Empty !"
            }
        }
    }

    //-------------------------------------------------------------------------
}
