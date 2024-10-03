/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Window   2.2
import QtQuick.Controls 1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0

Rectangle {
    id:     _root
    color:  qgcPal.window
    z:      QGroundControl.zOrderTopMost

    signal popout()

    ExclusiveGroup { id: setupButtonGroup }

    readonly property real  _defaultTextHeight:     ScreenTools.defaultFontPixelHeight
    readonly property real  _defaultTextWidth:      ScreenTools.defaultFontPixelWidth
    readonly property real  _horizontalMargin:      _defaultTextWidth / 2
    readonly property real  _verticalMargin:        _defaultTextHeight / 2
    readonly property real  _buttonWidth:           _defaultTextWidth * 18

    GeoTagController {
        id: geoController
    }

    LogDownloadController {
        id: logController
    }

    QGCFlickable {
        id:                 buttonScroll
        width:              buttonColumn.width
        anchors.topMargin:  _defaultTextHeight / 2
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        anchors.leftMargin: _horizontalMargin
        anchors.left:       parent.left
        contentHeight:      buttonColumn.height
        flickableDirection: Flickable.VerticalFlick
        clip:               true

        Column {
            id:         buttonColumn
            width:      _maxButtonWidth
            spacing:    _defaultTextHeight / 2

            property real _maxButtonWidth: 0

            Component.onCompleted: reflowWidths()

            // I don't know why this does not work
            Connections {
                target:         QGroundControl.settingsManager.appSettings.appFontPointSize
                onValueChanged: buttonColumn.reflowWidths()
            }

            function reflowWidths() {
                buttonColumn._maxButtonWidth = 0
                for (var i = 0; i < children.length; i++) {
                    buttonColumn._maxButtonWidth = Math.max(buttonColumn._maxButtonWidth, children[i].width)
                }
                for (var j = 0; j < children.length; j++) {
                    children[j].width = buttonColumn._maxButtonWidth
                }
            }

            Repeater {
                id:     buttonRepeater

                //Added by DST
                model: {//QGroundControl.corePlugin ? QGroundControl.corePlugin.analyzePages : []
                    var filtered = []
                    if(QGroundControl.corePlugin){
                        var analyzePages = QGroundControl.corePlugin.analyzePages;
                        for(var i=0;i<analyzePages.length;i++){
                            var item = analyzePages[i]
                            if((item.title == "Log Download" && mainWindow.showLogDownload) ||  (item.title == "GeoTag Images" && mainWindow.showGeoTag) ||
                                    (item.title == "MAVLink Console" && mainWindow.showMavConsole) || (item.title == "MAVLink Inspector" && mainWindow.showMavInsp) ||
                                    (item.title == "Vibration" && mainWindow.showVibration) || (item.title == "Activity Logs" && mainWindow.showactivityLogs)){
                                filtered.push(item)
                            }else{}
                        }
                    }
                    console.log("DATA: ",filtered)
                    panelLoader.source = filtered[0].url
                    return filtered;
                }

                Component.onCompleted: {//itemAt(0).checked = true
                    if(buttonRepeater.count > 0){
                        itemAt(0).checked = true
                    }
                }
                //
                SubMenuButton {
                    id:                 subMenu
                    imageResource:      modelData.icon
                    setupIndicator:     false
                    exclusiveGroup:     setupButtonGroup
                    text:               modelData.title

                    onClicked: {
                        panelLoader.source  = modelData.url
                        panelLoader.title   = modelData.title
                        checked             = true
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
        anchors.left:           buttonScroll.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width:                  1
        color:                  qgcPal.windowShade
    }

    Loader {
        id:                     panelLoader
        anchors.topMargin:      _verticalMargin
        anchors.bottomMargin:   _verticalMargin
        anchors.leftMargin:     _horizontalMargin
        anchors.rightMargin:    _horizontalMargin
        anchors.left:           divider.right
        anchors.right:          parent.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        //source:                 "LogDownloadPage.qml"

        property string title

        Connections {
            target:     panelLoader.item
            onPopout:   mainWindow.createrWindowedAnalyzePage(panelLoader.title, panelLoader.source)
        }
    }
}
