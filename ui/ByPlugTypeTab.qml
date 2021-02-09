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
import Ubuntu.Layouts 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../components"

Tab {
    title: i18n.tr("Plug Type")
    Component.onCompleted: pagestack_plugsANDsockets.push(mainPlugsPage)

    onWidthChanged: on_mainView_width_changed()

    // properties
    property string selected_plug: "A"
    property string plug_full_info: "The Type A electrical plug (or flat blade attachment plug) is an ungrounded plug with two flat parallel pins. Although the American and Japanese plugs appear identical, the neutral pin on the American plug is wider than the live pin, whereas on the Japanese plug both pins are the same size. As a result, Japanese plugs can be used in the US but often not the other way around.\n\nThe pins on Type A and Type B plugs have a hole near the tip that fits into ‘bumps’ found on the contact wipers of some sockets, so that the pins are gripped more tightly allowing for better contact and also to prevent the plug from slipping out of the socket. Some sockets have spring-action blades that grip the sides of the pins, making the holes obsolete."
    property string plug_used_in: "Used in: North and Central America, Japan"

    property int plugViewPage_y: plugViewPage.y


    // this function defines if app runing in phone or tablet mode, and doing few tweaks for each mode.
    function on_mainView_width_changed(){
        if (width >= units.gu(20) && width <= units.gu(55) && appMode == "tablet"){
            appMode = "phone"
        } else if (width > units.gu(55) && appMode == "phone") {
            appMode = "tablet"
            if(pagestack_plugsANDsockets.currentPage == plugViewPage) {
                pagestack_plugsANDsockets.pop()

            } else if (pagestack_plugsANDsockets.currentPage == plugs_Page_list_of_countries) {
                pagestack_plugsANDsockets.pop()
                pagestack_plugsANDsockets.pop()
            }
        }
    }

    // main pagestack
    PageStack {
        id: pagestack_plugsANDsockets
        // this part hides and shows MainView header.
        onCurrentPageChanged: if( pagestack_plugsANDsockets.currentPage == mainPlugsPage ) {
                                  plugViewPageItem.y = (mainView.height)
                                  plugs_Page_list_of_countries_Item.x = mainView.width
                                  mainView.header.visible = true
                                  mainView.header.show()
                              } else if (pagestack_plugsANDsockets.currentPage == plugViewPage) {
                                  print("plug view")
                                  plugViewPageItem.y = 0
                                  mainView.header.hide()
                                  mainView.header.visible = false
                              } else if ( pagestack_plugsANDsockets.currentPage == plugs_Page_list_of_countries) {
                                  plugs_Page_list_of_countries_Item.x = 0
                                  mainView.header.hide()
                                  mainView.header.visible = false
                              }

        // mainPlugPage page for phone and tablet
        Page {
            id: mainPlugsPage
            Layouts {
                anchors.fill: parent
                layouts: [
                    // List of all plugs [ phone mode ]
                    ConditionalLayout {
                        name: "phone"
                        when: appMode == "phone"

                        // Listview for all plugs
                        ItemLayout {
                            item: "plugsListView"
                            anchors.fill: parent
                            anchors.margins: units.gu(2)
                        }
                    },
                    // This is conditional view for tablet mode.
                    ConditionalLayout {
                        name: "tablet"
                        when: appMode == "tablet"
                        Row {
                            // Left column in tablet mode with list of all Plugs
                            Item {
                                height: mainPlugsPage.height
                                width: mainPlugsPage.width/3
                                // adding some nice animation on width change.
                                Behavior on width {
                                    UbuntuNumberAnimation {
                                        duration: UbuntuAnimation.BriskDuration
                                    }
                                }
                                // adding Column to add some margins.
                                Column {
                                    spacing: units.gu(1)
                                    width: parent.width/3
                                    anchors {
                                        margins: units.gu(2)
                                        fill: parent
                                    }
                                    // list of all plugs ( the same as on phone mode )
                                    ItemLayout {
                                        item: "plugsListView"
                                        width: parent.width
                                        height: parent.height
                                    }
                                }

                            }
                            // Seperator between Left and right column in tablet mode
                            Item {
                                width: units.gu(1)
                                height: mainPlugsPage.height
                                Rectangle {
                                    anchors.fill: parent
                                    color: "black"
                                    opacity: 0.2
                                }
                            }
                            // Right column in tablet mode with selected plug info.
                            Item {
                                width: (mainPlugsPage.width / 3)*2 -units.gu(1)
                                height: mainPlugsPage.height

                                // Whole right side of the tablet mode. List with plug preview + informations + list of countries where its used.
                                PlugViewTabletComponent {
                                    anchors.fill: parent
                                    id: plugViewTablet
                                    plug: selected_plug
                                    used_in: plug_used_in
                                    full_info: plug_full_info
                                }
                            }
                        }
                    }

                ]
                // ListView of all plugs
                ListView {
                    Layouts.item: "plugsListView"
                    model: plugsMODEL.model
                    clip: true
                    spacing: units.gu(1)
                    delegate: ListItem.Subtitled {
                        height: units.gu(7) // this haight is set here as when its not I get errors ? possible bug in SDK.
                        text: '<font color="#003355">Plug '+type+"</font></b>"
                        icon: Qt.resolvedUrl("../img/plugs/%_3d_plug_l.png").arg(type)
                        progression: true
                        subText: '<font color="white"><i>'+used_in+'</font></i>'
                        onClicked: {
                            if(appMode == "phone") {
                                pagestack_plugsANDsockets.push(plugViewPage)
                            }
                            selected_plug = type
                            plug_full_info = full_info
                            plug_used_in = used_in
                            list_of_countries_plug_is_used.query = '$.root.countries[?(@.plug.value[0] == "%1" || @.plug.value[1] == "%2" || @.plug.value[2] == "%3" || @.plug.value[3] == "%4")]'.arg(type).arg(type).arg(type).arg(type)
                        }
                    }
                }
            }
        }

        // this is page for plug view ( plug preview + information ) used in phone mode.
        Page {
            id: plugViewPage
            visible: false
            Item {
                id: plugViewPageItem
                width: parent.width
                height: parent.height
                Behavior on y {
                    UbuntuNumberAnimation {
                        duration: UbuntuAnimation.BriskDuration
                    }
                }

                // precreated component for plug view in phone mode.
                PlugViewPhoneComponent {
                    id: plugViewPhoneComponent
                    width: parent.width
                    height: parent.height
                    plug: selected_plug
                    used_in: plug_used_in
                    full_info: plug_full_info
                }
            }
        }

        // page for list of countries where selected plug is used. ( applies only for phone mode )
        Page {
            id: plugs_Page_list_of_countries
            visible: false
            Item {
                id: plugs_Page_list_of_countries_Item
                width: parent.width
                height: parent.height
                Behavior on x {
                    UbuntuNumberAnimation {
                        duration: UbuntuAnimation.BriskDuration
                    }
                }

                Column {
                    anchors.fill: parent
                    spacing: units.gu(1)
                    anchors.margins: units.gu(2)
                    Label {
                        text: i18n.tr("Plug") + " " + selected_plug + " " + i18n.tr("is used in") + ":"
                        fontSize: "large"
                        color: "#003355"
                    }

                    // list of countries where plug is used.
                    ListView {
                        width: parent.width
                        height: parent.height - units.gu(2)
                        clip: true
                        model: list_of_countries_plug_is_used.model
                        delegate: ListItem.Standard {
                            text: '<font color="#003355">'+location+"</font>"
                            icon: Qt.resolvedUrl("../img/flags/%.png").arg(countryCode)
                            iconFrame: false

                        }
                    }

                }


            }
        }
    }
}
