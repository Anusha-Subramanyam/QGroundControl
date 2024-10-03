import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtGraphicalEffects 1.15

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0

Rectangle {
    id: dashrect
    color:"transparent"

    property alias bckbuttonmousearea: bckbuttonmousearea

    QGCPalette { id: qgcPal }

    Rectangle{
        id: toolbar
        color: qgcPal.toolbarBackground
        width: parent.width
        height: parent.height*0.1

        Rectangle{
            id: backButton
            width: parent.height
            height: parent.height
            color: "transparent"
            anchors.right: parent.right
            anchors.rightMargin: parent.height*0.1

            Image{
                id:home
                source: "/custom/img/logout.png"
                width: parent.height*0.5
                height: parent.height*0.5
                anchors.centerIn: parent

                ColorOverlay{
                    anchors.fill: parent
                    source: home
                    color:qgcPal.text
                }
            }

            MouseArea{
                id: bckbuttonmousearea
                anchors.fill: parent

                onPressed: {
                    backButton.opacity = 0.5
                }

                onReleased: {
                    backButton.opacity = 1
                }
            }
        }
    }

    Rectangle{
        id: content
        color:qgcPal.windowShadeDark
        width: parent.width
        height: parent.height*0.9
        anchors.top: toolbar.bottom

        Rectangle{
            id: headtxtRect
            width: parent.width*0.96
            height: parent.height*0.08
            color: qgcPal.button
            border.color: qgcPal.windowShade
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.03
            radius: 6
        }

        Rectangle{
            id: userprofileRect
            width: parent.width*0.28
            height: parent.height*0.5
            color: qgcPal.button
            border.color: qgcPal.windowShade
            border.width: 1
            anchors.top: headtxtRect.bottom
            anchors.topMargin: parent.height*0.03
            anchors.left: parent.left
            anchors.leftMargin: parent.width*0.02
            radius: 6
        }

        Rectangle{
            id: activeDronesRect
            width: parent.width*0.28
            height: parent.height*0.5
            color: qgcPal.button
            border.color: qgcPal.windowShade
            border.width: 1
            anchors.top: headtxtRect.bottom
            anchors.topMargin: parent.height*0.03
            anchors.left: userprofileRect.right
            anchors.leftMargin: parent.width*0.02
            radius: 6
        }

        Rectangle{
            id: paramRect
            width: parent.width*0.33
            height: parent.height*0.8
            color: qgcPal.button
            border.color: qgcPal.windowShade
            border.width: 1
            anchors.top: headtxtRect.bottom
            anchors.topMargin: parent.height*0.03
            anchors.left: activeDronesRect.right
            anchors.leftMargin: parent.width*0.02
            radius: 6
        }
    }

}
