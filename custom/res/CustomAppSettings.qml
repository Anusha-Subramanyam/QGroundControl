/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0

Rectangle {
    id:     settingsView
    color:  qgcPal.window
    z:      QGroundControl.zOrderTopMost

    readonly property real _defaultTextHeight:  ScreenTools.defaultFontPixelHeight
    readonly property real _defaultTextWidth:   ScreenTools.defaultFontPixelWidth
    readonly property real _horizontalMargin:   _defaultTextWidth / 2
    readonly property real _verticalMargin:     _defaultTextHeight / 2
    readonly property real _buttonHeight:       ScreenTools.isTinyScreen ? ScreenTools.defaultFontPixelHeight * 3 : ScreenTools.defaultFontPixelHeight * 2

    property bool _first: true

    property bool _commingFromRIDSettings:  false

    QGCPalette { id: qgcPal }

    Component.onCompleted: {
        //-- Default Settings
        if (globals.commingFromRIDIndicator) {
            __rightPanel.source = "qrc:/qml/RemoteIDSettings.qml"
            globals.commingFromRIDIndicator = false
        } else {
            //__rightPanel.source = QGroundControl.corePlugin.settingsPages[QGroundControl.corePlugin.defaultSettings].url     //Added by DST
        }
    }

    QGCFlickable {
        id:                 buttonList
        width:              buttonColumn.width
        anchors.topMargin:  _verticalMargin
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        anchors.leftMargin: _horizontalMargin
        anchors.left:       parent.left
        contentHeight:      buttonColumn.height + _verticalMargin
        flickableDirection: Flickable.VerticalFlick
        clip:               true

        ColumnLayout {
            id:         buttonColumn
            spacing:    _verticalMargin

            property real _maxButtonWidth: 0

            Repeater {
                model:  {//QGroundControl.corePlugin.settingsPages
                    var filtered = []
                    if(QGroundControl.corePlugin){
                        var settingPages = QGroundControl.corePlugin.settingsPages;
                        for(var i=0;i<settingPages.length;i++){
                            var item = settingPages[i]
                            if((item.title == "General" && mainWindow.showgenTab) || (item.title == "Comm Links" && mainWindow.showCommLink) ||
                                    (item.title == "Offline Maps" && mainWindow.showOffMap) || (item.title == "MAVLink" && mainWindow.showMavlink) ||
                                    (item.title == "Remote ID" && mainWindow.showRemoteID) || (item.title == "Console" && mainWindow.showConsole) ||
                                    (item.title == "Help" && mainWindow.showHelp) || (item.title == "Mock Link" && mainWindow.showMockLink) ||
                                    (item.title == "Debug" && mainWindow.showDebug) || (item.title == "Palette Test" && mainWindow.showPalette)){
                                filtered.push(item)
                            }else{}
                        }

                    }
                    console.log("DATA: ",filtered)
                    __rightPanel.source = filtered[0].url
                    return filtered;
                }
                //
                QGCButton {
                    height:             _buttonHeight
                    text:               modelData.title
                    autoExclusive:      true
                    Layout.fillWidth:   true
                    visible:            modelData.url != "qrc:/qml/RemoteIDSettings.qml" ? true : QGroundControl.settingsManager.remoteIDSettings.enable.rawValue

                    onClicked: {
                        if (mainWindow.preventViewSwitch()) {
                            return
                        }
                        if (__rightPanel.source !== modelData.url) {
                            __rightPanel.source = modelData.url
                        }
                        checked = true
                    }

                    Component.onCompleted: {
                        if (globals.commingFromRIDIndicator) {
                            _commingFromRIDSettings = true
                        }
                        if(_first) {
                            _first = false
                            checked = true
                        }
                        if (_commingFromRIDSettings) {
                            checked = false
                            _commingFromRIDSettings = false
                            if (modelData.url == "qrc:/qml/RemoteIDSettings.qml") {
                                checked = true
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id:                     divider
        anchors.topMargin:      _verticalMargin
        anchors.bottomMargin:   _verticalMargin
        anchors.leftMargin:     _horizontalMargin
        anchors.left:           buttonList.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width:                  1
        color:                  qgcPal.windowShade
    }

    //-- Panel Contents
    Loader {
        id:                     __rightPanel
        anchors.leftMargin:     _horizontalMargin
        anchors.rightMargin:    _horizontalMargin
        anchors.topMargin:      _verticalMargin
        anchors.bottomMargin:   _verticalMargin
        anchors.left:           divider.right
        anchors.right:          parent.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
    }
}

