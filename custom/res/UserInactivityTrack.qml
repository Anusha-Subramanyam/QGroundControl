import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Controls 1.3
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs  1.2
import QtQuick.Layouts      1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0


Item {

    property var inactivityTime: 45
    property alias applybuttonmousearea: applybuttonmousearea
    property alias intervalComboBox: timecombobox.currentText

    Rectangle{
        id: mainRect
        anchors.fill: parent
        color: qgcPal.text

        Text{
            id: heading
            text: "Configure User Inactivity Time"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height*0.04
            anchors.leftMargin: parent.height*0.05
            font.pixelSize: parent.height*0.04
            color: qgcPal.windowShadeDark
        }
        Text{
            id: subheading
            text: "Configure the user inactivity time based on which the user will be automatically logged out after the specified period of inactivity."
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height*0.12
            anchors.leftMargin: parent.height*0.05
            font.pixelSize: parent.height*0.022
            wrapMode: Text.Wrap
            width: parent.width*.8
            color: qgcPal.windowShadeDark
        }

        Rectangle{
            id: content
            color: "beige"
            border.color: qgcPal.windowShade
            width:parent.width*0.5
            height: parent.height*0.35
            anchors.top: subheading.bottom
            anchors.left: parent.left
            anchors.topMargin: parent.height*0.08
            anchors.leftMargin: parent.height*0.05

            Text{
                id: content1
                text: "Current Inactivity Timeout Set: "+inactivityTime
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: parent.height*0.12
                anchors.leftMargin: parent.height*0.08
                font.pixelSize: parent.height*0.07
                color: qgcPal.windowShadeDark
            }

            Text{
                id: content2
                text: "Change Inactivity Timeout Interval: "
                anchors.top: content1.bottom
                anchors.left: parent.left
                anchors.topMargin: parent.height*0.12
                anchors.leftMargin: parent.height*0.08
                font.pixelSize: parent.height*0.07
                color: qgcPal.windowShadeDark
            }

            ComboBox {
                id: timecombobox
                width: parent.width*0.3
                height: parent.height*0.12

                anchors.verticalCenter: content2.verticalCenter
                anchors.left: content2.right
                anchors.leftMargin: parent.width*0.02

                model: ListModel {
                    ListElement { text: "1 minute" }
                    ListElement { text: "15 minutes" }
                    ListElement { text: "30 minutes" }
                    ListElement { text: "45 minutes" }
                    ListElement { text: "60 minutes" }
                    ListElement { text: "90 minutes" }
                    ListElement { text: "120 minutes" }
                }

                delegate: ItemDelegate {
                    width: timecombobox.width
                    height: timecombobox.height

                    contentItem:Rectangle {
                        anchors.fill: parent
                        color: highlighted ? "black" : "white"  // Set the background color of the item

                        Text {
                            text: modelData
                            font.bold: false
                            color: highlighted ? "white" : "black"
                            font.pixelSize: parent.height * 0.4
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width*.05
                        }
                    }
                }
                currentIndex: 0
                indicator: Image{
                    id: indicator
                    source: "/custom/img/logout.png"
                    height: parent.height*.8
                    width: parent.height*.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width*.01
                    rotation: timecombobox.popup.visible ? 180 : 0
                }

                // Display the selected data
                contentItem: Rectangle{
                    anchors.fill:parent
                    width: timecombobox.width
                    height: timecombobox.height
                    color: "white"
                    border.color: "black"
                    border.width: 1

                    Text {
                        text: timecombobox.currentText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width*.05
                        color: "black"
                        font.pixelSize: parent.height * 0.4
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                    }
                }

            }

            Rectangle{
                id: applybutton
                width: parent.width*0.25
                height: parent.height*0.17
                color: qgcPal.windowShade
                radius: height*0.2
                border.color: qgcPal.windowShade
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: parent.height*0.22
                anchors.rightMargin: parent.width*0.12

                Text{
                    text: "Apply"
                    font.pixelSize: parent.height*0.4
                    color: qgcPal.text
                    anchors.centerIn: parent
                }

                MouseArea{
                    id: applybuttonmousearea
                    anchors.fill: parent

                    onPressed: {
                        applybutton.opacity = 0.5
                    }
                    onReleased: {
                        applybutton.opacity = 1
                    }
                }
            }

        }
    }
}
