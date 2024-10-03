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

    signal openEdit()
    signal closeEdit()
    property var rowSelected: 0
    property var rowid: ""
    property var rowname: ""
    signal roleUpdated(string name)
    signal roleChanged(int index,string newName)
    Rectangle{
        id: mainRect
        anchors.fill: parent
        color: qgcPal.windowShade

        Text{
            id: heading
            text: "User Roles and Permissions"
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
                source: "/custom/img/AddRole.png"
                width: parent.height*0.5
                height: parent.height*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.height*0.4
            }

            Text {
                text: qsTr("Add Role")
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
                    openEdit()
                    mainRect.enabled = false
                    mainRect.opacity = 0.8
                    roleregister.visible = true
                    roleregister.enabled = true
                    roleregister.roleID = ""
                    roleregister.roleName = ""
                    roleregister.roleDescp = ""
                    roleregister.errorfieldtxt = ""
                    roleregister.submitbuttontxt.text = "CREATE"
                    roleregister.heading = "USER ROLE REGISTRATION"
                    roleregister.flick = 0
                    roleregister.uncheckPerm()
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
                placeholderText: "Search Role"
                height: parent.height
                width: parent.width*0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.left:parent.left
                anchors.leftMargin: parent.height*0.15
                style: Rectangle{
                    anchors.fill: parent
                    color:"transparent"
                }

                onTextChanged:{
                    if(text == ""){
                        rolepermModel.resetModel()
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
                            rolepermModel.filterModel(searchval.text)
                        }
                    }
                }
            }
        }

        Rectangle{
            id: roleid
            width: tableRect.width*.0625
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: tableRect.left
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Role ID")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: rolename
            width: tableRect.width*.211
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: roleid.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Role Name")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: roledescp
            width: tableRect.width*.534
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: rolename.right
            color: qgcPal.windowShadeLight
            border.color: qgcPal.windowShade
            border.width: 1

            Text {
                text: qsTr("Description")
                color: qgcPal.text
                font.pixelSize: parent.height*.4
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle{
            id: edit
            width: tableRect.width*.194
            height: parent.height*0.05
            anchors.top: heading.bottom
            anchors.topMargin: parent.height*0.14
            anchors.left: roledescp.right
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

        // Rectangle{
        //     id: edit
        //     width: tableRect.width*.096
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: roledescp.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1

        //     Text {
        //         text: qsTr("Edit")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

        // Rectangle{
        //     id: deleteuser
        //     width: tableRect.width*.098
        //     height: parent.height*0.05
        //     anchors.top: heading.bottom
        //     anchors.topMargin: parent.height*0.14
        //     anchors.left: edit.right
        //     color: qgcPal.windowShadeLight
        //     border.color: qgcPal.windowShade
        //     border.width: 1


        //     Text {
        //         text: qsTr("Delete")
        //         color: qgcPal.text
        //         font.pixelSize: parent.height*.4
        //         font.bold: true
        //         anchors.centerIn: parent
        //     }
        // }

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
                model: rolepermModel

                TableViewColumn {
                    role: "roleid"
                    title: "roleid"
                    width: parent.width*.05

                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: model ? qsTr(model.roleid) : ""  // Display the setup or any other data
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
                    role: "rolename"
                    title: "rolename"
                    width: parent.width*.17

                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: model ? model.rolename : ""

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
                    role: "roledesp"
                    title: "roledesp"
                    width: parent.width*.43


                    delegate: Item {
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "transparent"

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: parent.height*0.1
                                text: model ? model.roledesp : ""
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
                    role: "editrole"
                    title: "editrole"
                    width: parent.width*.156

                    delegate: Item {
                        Rectangle {
                            id: editrolebtn
                            width: parent.width
                            height: parent.height
                            color: "transparent"
                            Image {
                                source: model ? model.editrole : ""//model.edituser
                                height: parent.height*.7
                                width: parent.height*.7
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                id: editrolebtnmousearea
                                anchors.fill: parent

                                onPressed: {
                                    editrolebtn.opacity = 0.5
                                }

                                onReleased: {
                                    editrolebtn.opacity = 1
                                }

                                onClicked: {
                                    rowSelected = styleData.row
                                    rowid = model.roleid
                                    rowname = model.rolename
                                    openEdit()
                                    console.log("styleData.row === ",styleData.row)
                                    mainRect.enabled = false
                                    mainRect.opacity = 0.8

                                    roleregister.editRoleJson(model.perm)

                                    roleregister.visible = true
                                    roleregister.enabled = true
                                    roleregister.roleID = model.roleid
                                    roleregister.roleName = model.rolename
                                    roleregister.roleDescp = model.roledesp
                                    roleregister.errorfieldtxt = ""
                                    roleregister.submitbuttontxt.text = "EDIT"
                                    roleregister.heading = "EDIT USER ROLE"
                                    roleregister.flick = 0
                                }
                            }
                        }
                    }
                }
                // TableViewColumn {
                //     role: "deleterole"
                //     title: "deleterole"
                //     width: parent.width*.078

                //     delegate: Item {
                //         Rectangle {
                //             id: deletebtn
                //             width: parent.width
                //             height: parent.height
                //             color: "transparent"

                //             Image {
                //                 source: (model) ? model.deleterole : ""
                //                 height: parent.height*.7
                //                 width: parent.height*.7
                //                 anchors.centerIn: parent
                //             }
                //             MouseArea{
                //                 anchors.fill: parent

                //                 onPressed: {
                //                     deletebtn.opacity = 0.5
                //                 }

                //                 onReleased: {
                //                     deletebtn.opacity = 1
                //                 }

                //                 onClicked: {
                //                     console.log("delete item = ",styleData.row)
                //                     var user = model.userid
                //                     mainWindow.showMessageDialog("Deleting User",
                //                                                  qsTr("Are you sure you want to Delete User?"),
                //                                                  StandardButton.Yes | StandardButton.No,
                //                                                  function() {
                //                                                      //delete the user
                //                                                      opCls.deleteRoleConfigfile(model.roleid)
                //                                                      rolepermModel.deleteRoles(styleData.row)
                //                                                      //roleModel.deleteData(styleData.row)
                //                                                      //dstDb.deleteUser(user)
                //                                                      //tableviewcomp.setModel(nullptr)

                //                                                  })
                //                 }
                //             }
                //         }
                //         // Image {
                //         //     id: line
                //         //     // visible: styleData.row===5? false : true
                //         //     source: "img/LineIcon.svg"
                //         //     height: parent.height*.03
                //         //     width: parent.width*95
                //         //     x: parent.width*(-5.5)
                //         //     y: parent.height*1
                //         // }
                //     }
                // }

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

    RoleRegistration{
        id: roleregister
        anchors.fill: parent
        visible: false
        enabled: false

        submitbuttonmousearea.onClicked:{
            if(roleID != "" &&  roleName != "" && roleDescp != ""){
                if(submitbuttontxt.text == "CREATE"){
                    if(rolepermModel.roleExists(roleID) == -1){
                        closeEdit()
                        formRoleJson()
                        opCls.addRoleConfigfile(maincontainer);
                        //add role in dropdown
                        roleUpdated(roleName);
                        roleregister.visible = false
                        roleregister.enabled = false
                        mainRect.enabled = true
                        mainRect.opacity = 1
                    }else{
                        errorfieldtxt = "Role ID Already Exists"
                    }

                }else if(submitbuttontxt.text == "EDIT"){
                    if(rolepermModel.roleExists(roleID) == -1 || roleID == rowid){
                        closeEdit()
                        mainWindow.showMessageDialog("Editing User",
                                                     qsTr("Are you sure you want to Save Changes?"),
                                                     StandardButton.Yes | StandardButton.No,
                                                     function() {
                                                         formRoleJson()
                                                         opCls.deleteRoleConfigfile(rowid)
                                                         rolepermModel.deleteRoles(rowSelected)
                                                         opCls.addRoleConfigfile(maincontainer)
                                                         if(roleName != rowname){
                                                            roleChanged(rowSelected,roleName)
                                                         }

                                                         //delete the user
                                                         //opCls.editUserData(rowSelected+1, regUserid, regPassword, combobox.currentIndex+1)
                                                     })
                        roleregister.visible = false
                        roleregister.enabled = false
                        mainRect.enabled = true
                        mainRect.opacity = 1
                    }
                    else{
                        errorfieldtxt = "Role ID Already Exists"
                    }
                }else{;}
            }else{
                errorfieldtxt = "Fields cannot be Empty !"
            }
        }


        closebuttonmousearea.onClicked: {
            closeEdit()
            mainRect.enabled = true
            mainRect.opacity = 1
            roleregister.visible = false
            roleregister.enabled = false
        }
    }

}
