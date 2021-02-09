/*
 * Copyright (C) 2014 Szymon Waliczek.
 *
 * Authors:
 *  Szymon Waliczek <majsterrr@gmail.com>
 *
 * This file is part of SocketWorld app for Ubuntu Touch
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.3
import QtGraphicalEffects 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../components"


Item {
    property string plug/*: plug_label.text*/
    property string used_in/*: used_in_label.text*/
    property alias full_info: full_info_label.text



    ListModel {
        id: plugImagesMODEL
        ListElement { view: "_3d_plug_l" }
        ListElement { view: "_3d_socket_l" }
        ListElement { view: "_diagram_plug_l" }
        ListElement { view: "_diagram_socket_l" }
    }
    Column {
        width: parent.width
        height: parent.height
//        spacing: units.gu(1)
        Behavior on width {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.BriskDuration
            }
        }
        Item {
            id: middle_column_header
            width: parent.width
            height: plug_label.height + plugs_listView.height  + units.gu(3)

            Column {
                anchors.fill: parent
                anchors.margins: units.gu(1)
                spacing: units.gu(0.5)
                clip: true
                Text {
                    id: plug_label
                    wrapMode: Text.WordWrap
                    color: "#003355"
                    font.pixelSize: units.gu(2.2)
                    text: "<b>"+i18n.tr("Plug ") + plug + "</b>"
                }
                ListView {
                    id: plugs_listView
                    model:plugImagesMODEL
                    width: parent.width
                    height: units.gu(17)
                    spacing: units.gu(2)
                    orientation: ListView.Horizontal
                    delegate: CategoryDelegate {
                        width: units.gu(17)
                        height: units.gu(17)
//                        label: view
                        thumbnail: Qt.resolvedUrl("../img/plugs/%.png").arg(plug+view)
                    }
                }
            }
        }
        // Seperator
        Item {
            width: parent.width
            height: units.gu(1)
            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.2
            }
        }

        Item {
            width: parent.width
            height: parent.height - middle_column_header.height
            Row {
                width: parent.width
                height: parent.height
                Item {
                    width: parent.width / 2 - units.gu(0.5)
                    height: parent.height
                    clip: true
                    Column {
                        anchors.fill: parent
                        spacing: units.gu(1)
                        anchors.margins: units.gu(1)
                        Text {
                            id: used_in_label
                            width: parent.width
                            wrapMode: Text.WordWrap
                            font.pixelSize: units.gu(2.2)
                            color: "#003355"
                            text: "<b>"+i18n.tr("Information: ") + "</b>"
                        }

                        Flickable {
                            width: parent.width
                            height: parent.height
                            contentWidth: parent.width
                            contentHeight: plug_label.height + full_info_label.height + units.gu(3)
                            clip: true
                            Column {
                                anchors.fill: parent
//                                anchors.margins: units.gu(1)
                                anchors.leftMargin: units.gu(1)
                                spacing: units.gu(2)

                                Text {
                                    id: full_info_label
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: units.gu(2.2)
                                    color: "white"
                                }
                            }

                        }





                    }


                }
                // Seperator
                Item {
                    width: units.gu(1)
                    height: parent.height
                    Rectangle {
                        anchors.fill: parent
                        color: "black"
                        opacity: 0.2
                    }
                }

                //very right bottom pane with list of all countries where this plug is used
                Item {
                    width: parent.width / 2 - units.gu(0.5)
                    height: parent.height
                    clip: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: units.gu(1)
                        spacing: units.gu(1)
                        Text {
                            id: used_in_text_label
                            width: parent.width
                            font.pixelSize: units.gu(2.2)
                            color: "#003355"
                            text: "<b>"+i18n.tr("Used in: ") + "</b>"
                        }

                        ListView {
                            id: listView_of_countries_plug_is_used
                            width: parent.width
                            height: parent.height - used_in_text_label.height - units.gu(1)
                            clip: true
    //                        model: list_of_countries_plug_is_used
                            model: list_of_countries_plug_is_used.model
                            delegate: ListItem.Standard {
                                text: '<font color="#003355">'+location+"</font>"
                                icon: Qt.resolvedUrl("../img/flags/%.png").arg(countryCode)
    //                            text: "lol"
                                iconFrame: false
                            }

                        }

                    }

                }

            }
        }
    }





}
