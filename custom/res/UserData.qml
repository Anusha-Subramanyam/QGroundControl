import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Controls 1.3
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs  1.2
import QtQuick.Layouts      1.2
import QtQuick.Controls 1.4

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0

Item {

    signal closepopup()
    signal openpopup()
    property var rowSelected: 0
    property var username: ""
    property alias userrolemodel: userregister
    Rectangle{
        id: mainRect
        anchors.fill: parent
        color: qgcPal.windowShade

        Text{
            id: heading
            text: "User Management"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height*0.04
            anchors.leftMargin: parent.height*0.05
            font.pixelSize: parent.height*0.04
            color: qgcPal.text
        }

        Rectangle{
            id: createbtn
            width: parent.width*0.1
            height: parent.height*0.06
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1
            anchors.right: parent.right
            anchors.top:parent.top
            anchors.topMargin: parent.height*0.11
            anchors.rightMargin: parent.width*0.04
            radius: 5

            Image{
                id: create
                source: "/custom/img/AddUser.png"
                width: parent.height*0.5
                height: parent.height*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.height*0.4
            }

            Text {
                text: qsTr("Create")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: create.right
                anchors.leftMargin: parent.height*0.2
            }

            MouseArea{
                id: createbtnmousearea
                anchors.fill: parent
                onPressed: {
                    createbtn.opacity = 0.5
                }
                onReleased: {
                    createbtn.opacity = 1
                }
                onClicked: {
                    openpopup()
                    mainRect.enabled = false
                    mainRect.opacity = 0.8
                    userregister.visible = true
                    userregister.enabled = true
                    userregister.regUserid = ""
                    userregister.regPassword = ""
                    userregister.errorfieldtxt = ""
                    userregister.bgrect = "lightgrey"
                    userregister.combobox.currentIndex = 0
                    userregister.passwordHide = true
                    userregister.submitbuttontxt.text = "CREATE"
                    userregister.heading = "USER REGISTRATION"
                }
            }
        }

        Rectangle{
            id: searchbar
            width: parent.width*0.4
            height: parent.height*0.05
            color: "transparent"
            radius: 6
            border.color: qgcPal.text
            border.width: 1
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.03
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.05

            TextField{
                id: searchval
                text: ""
                font.pixelSize: parent.height*0.41
                textColor: qgcPal.text
                placeholderText: "Search User"
                height: parent.height
                width: parent.width*0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.left:parent.left
                anchors.leftMargin: parent.height*0.15

                style: Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                }

                onTextChanged:{
                    if(text == ""){
                        roleModel.resetModel()
                    }
                }
            }

            Rectangle{
                id: searchbtn
                width: parent.width*0.2
                height: parent.height*0.95
                color: qgcPal.windowShadeLight
                radius: 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: parent.height*0.05

                Text{
                    id: searchtxt
                    text: "Search"
                    anchors.centerIn: parent
                    font.pixelSize: parent.height*0.4
                    color: qgcPal.text
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        searchbtn.opacity = 0.5
                    }
                    onReleased: {
                        searchbtn.opacity = 1
                    }
                    onClicked: {
                        if(searchval.text != ""){
                            roleModel.filterModel(searchval.text)
                        }
                    }
                }
            }
        }

        Rectangle{
            id: userid
            width: tableRect.width*.186
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: tableRect.left
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("User ID")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: userrole
            width: tableRect.width*.149
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: userid.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Role")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: isactive
            width: tableRect.width*.086
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: userrole.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Status")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: usersince
            width: tableRect.width*.211
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: isactive.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("User Since")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: lastlogin
            width: tableRect.width*.211
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: usersince.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Last Login")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: edit
            width: tableRect.width*.08
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: lastlogin.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Edit")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: deleteuser
            width: tableRect.width*.079
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: edit.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Delete")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: tableRect
            width: parent.width*0.97
            height: parent.height*0.7
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.19
            color:"transparent"

            TableView {
                id: tableviewcomp
                anchors.fill: parent
                backgroundVisible: false
                frameVisible: true
                verticalScrollBarPolicy: ScrollBar.AsNeeded  // You can use ScrollBar.AlwaysOff or ScrollBar.AsNeeded as well
                model: roleModel

                TableViewColumn {
                    role: "userid"
                    title: "userid"
                    width: parent.width*.15

                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: parent.height*0.1
                                text: model ? qsTr(styleData.row+1 + ". " + model.userid) : ""  // Display the setup or any other data
                                font.pixelSize: parent.height*.53
                                color: qgcPal.text  // Set the text color
                                clip: true
                                elide: Text.ElideRight
                                wrapMode: Text.WrapAnywhere
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "role"
                    title: "role"
                    width: parent.width*.12

                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: model ? rolepermModel.getRoleParameter(styleData.row,"rolename") : ""
                                font.pixelSize: parent.height*.53
                                color: qgcPal.text  // Set the text color
                                clip: true
                                elide: Text.ElideRight
                                wrapMode: Text.WrapAnywhere
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "isactive"
                    title: "isactive"
                    width: parent.width*.07

                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Image {
                                source: model ? (model.isactive == "1") ? "/custom/img/ActiveUserIcn.png" : "/custom/img/InactiveUserIcn.png" : ""
                                height: parent.height*.7
                                width: parent.height*.7
                                anchors.centerIn: parent
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "usersince"
                    title: "usersince"
                    width: parent.width*.17


                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: parent.height*0.1
                                text: model && model.usersince != "-" ? opCls.getDateTime(model.usersince) : "-"
                                font.pixelSize: parent.height*.53
                                color: qgcPal.text  // Set the text color
                                clip: true
                                elide: Text.ElideRight
                                wrapMode: Text.WrapAnywhere
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "lastlogin"
                    title: "lastlogin"
                    width: parent.width*.17


                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"


                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: parent.height*0.1
                                text: model && model.lastlogin != "-" ? opCls.getDateTime(model.lastlogin) : "-"
                                font.pixelSize: parent.height*.53
                                color: qgcPal.text  // Set the text color
                                clip: true
                                elide: Text.ElideRight
                                wrapMode: Text.WrapAnywhere
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "edituser"
                    title: "edituser"
                    width: parent.width*.065

                    delegate: Item {
                        Rectangle {
                            id: edituserbtn
                            width: parent.width
                            height: parent.height
                            color: "transparent"
                            Image {
                                source: model ? model.edituser : ""//model.edituser
                                height: parent.height*.7
                                width: parent.height*.7
                                anchors.centerIn: parent

                            }
                            MouseArea{
                                id: edituserbtnmousearea
                                anchors.fill: parent

                                onPressed: {
                                    edituserbtn.opacity = 0.5
                                }

                                onReleased: {
                                    edituserbtn.opacity = 1
                                }

                                onClicked: {
                                    openpopup()
                                    rowSelected = styleData.row
                                    username = model.userid
                                    userregister.passwordValid = true
                                    console.log("styleData.row === ",styleData.row)
                                    mainRect.enabled = false
                                    mainRect.opacity = 0.8
                                    userregister.visible = true
                                    userregister.enabled = true
                                    userregister.regUserid = model.userid
                                    userregister.regPassword = model.password
                                    userregister.errorfieldtxt = ""
                                    userregister.bgrect = "lightgrey"
                                    userregister.combobox.currentIndex = userregister.combobox.indexOfValue(model.role)
                                    userregister.passwordHide = true
                                    userregister.submitbuttontxt.text = "EDIT"
                                    userregister.heading = "EDIT USER DATA"
                                }
                            }
                        }
                    }
                }
                TableViewColumn {
                    role: "deleteuser"
                    title: "deleteuser"
                    width: parent.width*.065

                    delegate: Item {
                        Rectangle {
                            id: deletebtn
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Image {
                                source: (model) ? model.deleteuser : ""
                                height: parent.height*.7
                                width: parent.height*.7
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent

                                onPressed: {
                                    deletebtn.opacity = 0.5
                                }

                                onReleased: {
                                    deletebtn.opacity = 1
                                }

                                onClicked: {
                                    console.log("delete item = ",styleData.row)
                                    var user = model.userid
                                    mainWindow.showMessageDialog("Deleting User",
                                                                 qsTr("Are you sure you want to Delete User?"),
                                                                 StandardButton.Yes | StandardButton.No,
                                                                 function() {
                                                                     //delete the user
                                                                     roleModel.deleteData(styleData.row)
                                                                     dstDb.deleteUser(user)
                                                                     //tableviewcomp.setModel(nullptr)

                                                                 })
                                }
                            }
                        }
                        // Image {
                        //     id: line
                        //     // visible: styleData.row===5? false : true
                        //     source: "img/LineIcon.svg"
                        //     height: parent.height*.03
                        //     width: parent.width*95
                        //     x: parent.width*(-5.5)
                        //     y: parent.height*1
                        // }
                    }
                }

                // TableViewColumn {
                //     role: "underline"
                //     title: "underline"
                //     width: tableviewcomp.width

                //     delegate: Item {
                //         Rectangle {
                //             width: parent.width*5
                //             height: parent.height*.02
                //             x: parent.width*(-1.6)
                //             y: parent.height*(-.17)
                //             color: "transparent"
                //             radius: parent.height*.1

                //             Image {
                //                 source: model.underline
                //                 height: parent.height*.85
                //                 width: parent.width
                //                 anchors.centerIn: parent
                //             }
                //         }
                //     }
                // }


                headerDelegate: Rectangle {
                    height: 0
                }

                rowDelegate: Rectangle {
                    id: rowitem
                    height: tableviewcomp.height/16//64//parent.height*4 // Set the height of each row
                    width: tableviewcomp.width
                    color: "transparent"
                    MouseArea{
                        anchors.fill:parent
                        hoverEnabled: true

                        onHoveredChanged: {
                            if(containsMouse){
                                rowitem.color = qgcPal.windowShadeLight
                            }
                            else{
                                rowitem.color = "transparent"
                            }
                        }
                    }
                }
            }


        }
    }

    UserRegister{
        id: userregister
        anchors.fill: parent
        visible: false
        enabled: false

        submitbuttonmousearea.onClicked:{
            if(regUserid != "" &&  regPassword != ""){

                if(passwordValid == true){
                    bgrect = "lightgrey"
                    if(submitbuttontxt.text == "CREATE"){
                        if(roleModel.userExists(regUserid) == -1){
                            closepopup()
                            //add user to DB and listmodel
                            opCls.userRegistration(regUserid,regPassword,combobox.currentText)
                            userregister.visible = false
                            userregister.enabled = false
                            mainRect.enabled = true
                            mainRect.opacity = 1
                        }else{
                            errorfieldtxt = "User ID Already Exists"
                        }

                    }else if(submitbuttontxt.text == "EDIT"){
                        if(roleModel.userExists(regUserid) == -1 || regUserid == username){
                            closepopup()
                            mainWindow.showMessageDialog("Editing User",
                                                         qsTr("Are you sure you want to Save Changes?"),
                                                         StandardButton.Yes | StandardButton.No,
                                                         function() {
                                                             //delete the user
                                                             opCls.editUserData(rowSelected+1, regUserid, regPassword, combobox.currentText)
                                                         })
                            userregister.visible = false
                            userregister.enabled = false
                            mainRect.enabled = true
                            mainRect.opacity = 1
                        }else{
                            errorfieldtxt = "User ID Already Exists"
                        }
                    }else{;}
                }else{
                    bgrect = "red"
                    errorfieldtxt = "Created Password is of wrong format"
                }
            }else{
                errorfieldtxt = "User ID/Password cannot be Empty !"
            }
        }


        closebuttonmousearea.onClicked: {
            closepopup()
            mainRect.enabled = true
            mainRect.opacity = 1
            userregister.visible = false
            userregister.enabled = false
        }
    }
}




















































//     import QtQuick                      2.11
//     import QtQuick.Controls             2.4
//     import QtQuick.Dialogs              1.3
//     import QtQuick.Layouts              1.11
//     import QtQuick.Controls             1.4
//     import QtQuick.Controls 2.15

//     import QGroundControl               1.0
//     import QGroundControl.Palette       1.0
//     import QGroundControl.FactSystem    1.0
//     import QGroundControl.FactControls  1.0
//     import QGroundControl.Controls      1.0
//     import QGroundControl.ScreenTools   1.0
//     import QGroundControl.Controllers   1.0

//     Item {
//         property var  maincontainer: []
//         property var flyView: []
//         property var menu: []
//         property var  analyzeTools: []
//         property var appSetting: []
//         property alias missid: missid
//         property alias teleid: teleid
//         property alias dashid: dashid
//         property alias manaUserid: manaUserid
//         property alias vehiclesetupid: vehiclesetupid
//         property alias parentBox: parentBox
//         property alias col1child1: col1child1
//         property alias col1child2: col1child2
//         property alias col1child3: col1child3
//         property alias col1child4: col1child4
//         property alias col1child5: col1child5
//         property alias col1child6: col1child6
//         property alias parentBox2: parentBox2
//         property alias col2child1: col2child1
//         property alias col2child2: col2child2
//         property alias col2child3: col2child3
//         property alias col2child4: col2child4
//         property alias col2child5: col2child5
//         property alias col2child6: col2child6
//         property alias col2child7: col2child7
//         property alias col2child8: col2child8
//         property alias col2child9: col2child9
//         property alias col2child10: col2child10


//         Rectangle{
//             id:mainrect
//             height: parent.height*0.6
//             width: parent.width*0.37
//             border.color: "gray"
//             border.width: 5
//             color: "black"
//             radius: 5
//             anchors.centerIn: parent
//             ScrollView{
//                 id:frame
//                 anchors.fill: parent
//                 clip: true
//                 ScrollBar.vertical.policy: ScrollBar.AlwaysOn

//                 Flickable{
//                     contentHeight: parent.height*1.8
//                     width: parent.width

//                     Text {
//                         id: maintxt
//                         text: qsTr("Edit Permission")
//                         font.pixelSize: 30
//                         color: "white"
//                         anchors.horizontalCenter: parent.horizontalCenter
//                     }

//                     Rectangle {
//                         height: mainrect.height*0.07
//                         width: mainrect.width*0.1
//                         border.color: "gray"
//                         anchors.right: parent.right
//                         anchors.rightMargin: 20
//                         anchors.top: parent.top
//                         anchors.topMargin: 10
//                         color: "black"
//                         Text {
//                             id: savetxt
//                             text: qsTr("Save")// This is available in all editors.
//                             font.pixelSize:20
//                             anchors.centerIn: parent
//                             color: "white"
//                         }

//                         MouseArea{
//                             anchors.fill: parent
//                             onClicked: {
//                                 if(missid.checked == true){
//                                     flyView.push("Planning")
//                                 }
//                                 if(teleid.checked == true){
//                                     flyView.push("Telemetry")
//                                 }
//                                 if(dashid.checked == true){
//                                     flyView.push("Dashboard")
//                                 }
//                                 if(manaUserid.checked==true){
//                                     menu.push("ManageUsers")
//                                 }
//                                 if(vehiclesetupid.checked==true){
//                                     menu.push("VehicleSetup")
//                                 }
//                                 if(parentBox.checkState==2){
//                                     analyzeTools.push("LogDownLoad")
//                                     analyzeTools.push("GeoTag")
//                                     analyzeTools.push("MavConsole")
//                                     analyzeTools.push("MavInsp")
//                                     analyzeTools.push("Vibration")
//                                     analyzeTools.push("ActivityLogs")
//                                 }
//                                 if(parentBox.checkState!=2){

//                                     if(col1child1.checked){
//                                          analyzeTools.push("LogDownLoad")
//                                     }
//                                     if(col1child2.checked){
//                                         analyzeTools.push("GeoTag")
//                                     }
//                                     if(col1child3.checked){
//                                         analyzeTools.push("MavConsole")
//                                     }
//                                     if(col1child4.checked){
//                                         analyzeTools.push("MavInsp")
//                                     }
//                                     if(col1child5.checked){
//                                          analyzeTools.push("Vibration")
//                                     }
//                                     if(col1child6.checked){
//                                         analyzeTools.push("ActivityLogs")
//                                     }
//                                 }

//                                 if(parentBox2.checkState==2){
//                                     menu.push("AppSettings")
//                                     appSetting.push("General")
//                                     appSetting.push("CommLinks")
//                                     appSetting.push("OfflineMaps")
//                                     appSetting.push("MavLink")
//                                     appSetting.push("RemoteID")
//                                     appSetting.push("Console")
//                                     appSetting.push("Help")
//                                     appSetting.push("MockLink")
//                                     appSetting.push("Debug")
//                                     appSetting.push("PaletteTest")
//                                 }

//                                 if(parentBox2.checkState!=2){


//                                     if(col2child1.checked){
//                                         appSetting.push("General")
//                                     }
//                                     if(col2child2.checked){
//                                         appSetting.push("CommLinks")
//                                     }
//                                     if(col2child3.checked){
//                                         appSetting.push("OfflineMaps")
//                                     }
//                                     if(col2child4.checked){
//                                         appSetting.push("MavLink")
//                                     }
//                                     if(col2child5.checked){
//                                         appSetting.push("RemoteID")
//                                     }
//                                     if(col2child6.checked){
//                                         appSetting.push("Console")
//                                     }
//                                     if(col2child7.checked){
//                                         appSetting.push("Help")
//                                     }
//                                     if(col2child8.checked){
//                                         appSetting.push("MockLink")
//                                     }
//                                     if(col2child9.checked){
//                                          appSetting.push("Debug")
//                                     }
//                                     if(col2child10.checked){
//                                         appSetting.push("PaletteTest")
//                                     }
//                                 }

//                                 console.log(flyView)
//                                 console.log(menu)
//                                 console.log(analyzeTools)
//                                 console.log(appSetting)
//                                 // opCls
//                                 maincontainer.push("4")
//                                 maincontainer.push("Aditya");
//                                 maincontainer.push(flyView);
//                                 maincontainer.push(menu);
//                                 maincontainer.push(analyzeTools);
//                                  maincontainer.push(appSetting);

//                                 opCls.addRoleConfigfile(maincontainer);
//                             }
//                         }
//                     }


//                     Column {
//                         id:col1
//                         anchors.top: maintxt.bottom
//                         anchors.left: parent.left
//                         anchors.leftMargin: 10
//                         anchors.topMargin: 10
//                         CheckBox {
//                             id:missid
//                             checked: false
//                             text: qsTr("Mission Planning")
//                             contentItem: Text {
//                                 text: parent.text
//                                 font: parent.font
//                                 // opacity: enabled ? 1.0 : 0.3
//                                 color: "white"
//                                 verticalAlignment: Text.AlignVCenter
//                                 leftPadding: parent.indicator.width + parent.spacing
//                             }
//                         }
//                         CheckBox {
//                             id:teleid
//                             checked: false
//                             text: qsTr("Telemetry data")
//                             contentItem: Text {
//                                 text: parent.text
//                                 font: parent.font
//                                 // opacity: enabled ? 1.0 : 0.3
//                                 color: "white"
//                                 verticalAlignment: Text.AlignVCenter
//                                 leftPadding: parent.indicator.width + parent.spacing
//                             }
//                         }
//                         CheckBox {
//                             id:dashid
//                             checked: false
//                             text: qsTr("Dashboard")
//                             contentItem: Text {
//                                 text: parent.text
//                                 font: parent.font
//                                 // opacity: enabled ? 1.0 : 0.3
//                                 color: "white"
//                                 verticalAlignment: Text.AlignVCenter
//                                 leftPadding: parent.indicator.width + parent.spacing
//                             }

//                         }
//                         CheckBox {
//                             id:manaUserid
//                             checked: false
//                             text: qsTr("Manage Users")
//                             contentItem: Text {
//                                 text: parent.text
//                                 font: parent.font
//                                 // opacity: enabled ? 1.0 : 0.3
//                                 color: "white"
//                                 verticalAlignment: Text.AlignVCenter
//                                 leftPadding: parent.indicator.width + parent.spacing
//                             }
//                         }
//                         CheckBox {
//                             id:vehiclesetupid
//                             checked: false
//                             text: qsTr("Vehicle Setup")
//                             contentItem: Text {
//                                 text: parent.text
//                                 font: parent.font
//                                 // opacity: enabled ? 1.0 : 0.3
//                                 color: "white"
//                                 verticalAlignment: Text.AlignVCenter
//                                 leftPadding: parent.indicator.width + parent.spacing
//                             }
//                         }

//                         Column {
//                             ButtonGroup {
//                                 id: childGroup
//                                 exclusive: false
//                                 checkState: parentBox.checkState

//                             }

//                             CheckBox {
//                                 id: parentBox
//                                 text: qsTr("Analyze Tools")
//                                 checkState: childGroup.checkState

//                                 onCheckStateChanged: {
//                                     console.log(parentBox.checkState)
//                                     console.log(parentBox.checked)
//                                     console.log("hiiii.............")
//                                 }

//                                 // checked: col1child1.checked && col1child2.checked && col1child3.checked && col1child4.checked && col1child5.checked && col1child6.checked
//                                 //            onCheckedChanged: {
//                                 //                col1child1.checked = checked;
//                                 //                col1child2.checked = checked;
//                                 //                col1child3.checked = checked;
//                                 //                col1child4.checked = checked;
//                                 //                col1child5.checked = checked;
//                                 //                col1child6.checked = checked;
//                                 //            }
//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }

//                             CheckBox {
//                                 id:col1child1
//                                 text: qsTr("LogDownLoad")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: childGroup

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }

//                             CheckBox {
//                                 id:col1child2
//                                 text: qsTr("GeoTag")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: childGroup

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col1child3
//                                 text: qsTr("MavConsole")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: childGroup

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col1child4
//                                 text: qsTr("MavInsp")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: childGroup

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col1child5
//                                 text: qsTr("Vibration")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: childGroup

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col1child6
//                                 text: qsTr("ActivityLogs")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: childGroup

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                         }

//                         Column {

//                             ButtonGroup {
//                                 id: col2childid
//                                 exclusive: false
//                                 checkState: parentBox2.checkState
//                             }

//                             CheckBox {
//                                 id: parentBox2
//                                 text: qsTr("Application settings")
//                                 checkState: col2childid.checkState

//                                 // checked: col2child1.checked && col2child2.checked && col2child3.checked && col2child4.checked && col2child5.checked && col2child6.checked && col2child7.checked && col2child8.checked && col2child9.checked && col2child10.checked
//                                 //            onCheckedChanged: {
//                                 //                col2child1.checked = checked;
//                                 //                col2child2.checked = checked;
//                                 //                col2child3.checked = checked;
//                                 //                col2child4.checked = checked;
//                                 //                col2child5.checked = checked;
//                                 //                col2child6.checked = checked;
//                                 //                col2child7.checked = checked;
//                                 //                col2child8.checked = checked;
//                                 //                col2child9.checked = checked;
//                                 //                col2child10.checked = checked;
//                                 //            }

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }

//                             CheckBox {
//                                 id:col2child1
//                                 text: qsTr("General")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }

//                             CheckBox {
//                                 id:col2child2
//                                 text: qsTr("CommLinks")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col2child3
//                                 text: qsTr("OfflineMaps")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col2child4
//                                 text: qsTr("MavLink")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid
//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }

//                             CheckBox {
//                                 id:col2child5
//                                 text: qsTr("RemoteID")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col2child6
//                                 text: qsTr("Console")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col2child7
//                                 text: qsTr("Help")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col2child8
//                                 text: qsTr("MockLink")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col2child9
//                                 text: qsTr("Debug")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }
//                             CheckBox {
//                                 id:col2child10
//                                 text: qsTr("PaletteTest")
//                                 leftPadding: indicator.width
//                                 ButtonGroup.group: col2childid

//                                 contentItem: Text {
//                                     text: parent.text
//                                     font: parent.font
//                                     // opacity: enabled ? 1.0 : 0.3
//                                     color: "white"
//                                     verticalAlignment: Text.AlignVCenter
//                                     leftPadding: parent.indicator.width + parent.spacing
//                                 }
//                             }

//                         }

//                     }


//                 }
//             }
//         }


//     }


// }
