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
import QtGraphicalEffects 1.0
import QtMultimedia 5.0
import Ubuntu.Components.Popups 1.3

Tab {
    id: byLocationTab
    title: i18n.tr("Location")
    Component.onCompleted: {
        pagestack.push(byLocationPage)
        loadPlugImagesModel("C,F")
    }

    onWidthChanged: on_mainView_width_changed()

    // vars for countryViewTablet anch countryViewPhone
    // [0] = country flag image path ( /home/user/..../pl.png )
    // [1] = country map image path ( /home/user/..../pl.png )
    // [2] = country name ( Poland, etc. )
    // [3] = frequency ( 50Hz, 60Hz )
    // [4] = voltage ( 220V, 120V, etc. )
    // [5] = plugs ( A, C, etc... )
    property var countryPreviewArray: [Qt.resolvedUrl("../img/flags/af.png"),Qt.resolvedUrl("../img/map/af.png"), "Afghanistan", "Frequency: 50Hz", "Voltage: 220V", "Plugs: C,F"]
    // countryPreviewArray filler function
    function countryPreviewArray_filler(index) {
        loadPlugImagesModel(jsonMainDB.model.get(index).plug.value.toString())
        var new_array = []
        /*[0]*/new_array.push(Qt.resolvedUrl("../img/flags/"+jsonMainDB.model.get(index).countryCode.toString()+".png"))
        /*[1]*/new_array.push(Qt.resolvedUrl("../img/map/"+jsonMainDB.model.get(index).countryCode.toString()+".png"))
        /*[2]*/new_array.push(jsonMainDB.model.get(index).location.toString())
        /*[3]*/new_array.push("Frequency: " + jsonMainDB.model.get(index).frequency.value.toString())
        /*[4]*/new_array.push("Voltage: " + jsonMainDB.model.get(index).voltage.value.toString())
        /*[5]*/new_array.push("Plugs: " + jsonMainDB.model.get(index).plug.value.toString())
        countryPreviewArray = new_array
    }

    // width and height for plugs preview component ( you can find it at very bottom of that page )
    property alias preview_width: plugPreview.width
    property alias preview_heigth: plugPreview.height



    // ListModel for coutry view for different plug types ( plug A, plug B, etc. )
    ListModel {
        id: plugImagesMODEL
    }

    // ListModel for countryViewPhone and countryViewTablet
    ListModel {
        id: plugImagesDetailsMODEL
        ListElement { view: "_3d_plug_l" }
        ListElement { view: "_3d_socket_l" }
        ListElement { view: "_diagram_plug_l" }
        ListElement { view: "_diagram_socket_l" }
    }

    //click effect [downloaded from http://www.freesound.org/people/schluppipuppie/sounds/88367/ ]
    SoundEffect {
        id: soundEffect_click
        source: Qt.resolvedUrl("../sound/2.wav")
    }

    // creating model for country view ( plug A, plug B, etc.. )
    function loadPlugImagesModel(plugs) {
        var list = []
        plugImagesMODEL.clear()
        for(var i = 0; i < plugs.length; i++) {
            if(plugs[i] !== ","){
                list.push({"image": plugs[i]})
            }
        }
        plugImagesMODEL.append(list)
    }

    // this function defines if app runing in phone or tablet mode, and doing few tweaks for each mode.
    function on_mainView_width_changed(){
        if (width >= units.gu(20) && width <= units.gu(55)){
            appMode = "phone"
        } else if (width > units.gu(55) ) {
            appMode = "tablet"
            if(pagestack.currentPage == countryViewPhone) {
                pagestack.pop()
            }
        }
//        console.debug(time_stamp() + "width changed.")

    }



    // function for searching for country, takes agr string [ serching first leters and country codes eg. PL or GB ]
    function country_search(chars){
        jsonMainDB.query = '$.root.countries[?(@.location.slice(0,%1).toLowerCase() == "%2".toLowerCase() || @.countryCode.toLowerCase() == "%2".toLowerCase())]'.arg(chars.length).arg(chars)
    }

    // funciont to reaload jsonMainDB
    function jsonMainDB_reload() {
        jsonMainDB.query = '$.root.countries[?(@.location).slice(0,1).toLowerCase() == "a"]'
//        jsonMainDB.query = "$.root.countries[*]"
//        jsonMainDB.query
//        jsonMainDB.source = Qt.resolvedUrl("../mainDB.json")
//        jsonMainDB.updateJSONModel()
    }

    //Formating text for Plug Preview
    function slicingStringForPlugPrevie(socket, string) {
        var newString = string.slice(1,string.length-2).split("_")
        newString = newString[1] + " " + socket
        return newString.charAt(0).toUpperCase() + newString.slice(1);
    }

    //main page stack.
    PageStack {
        id: pagestack
        onCurrentPageChanged: {
            if(pagestack.currentPage == byLocationPage){
                countryViewPhone.itemView_Page_y = (mainView.height)
                mainView.header.visible = true
                mainView.header.show()

            } else if (pagestack.currentPage == countryViewPhone){
                mainView.header.hide()
                mainView.header.visible = false
                countryViewPhone.itemView_Page_y = 0
            };
        }


        Page {
            id: byLocationPage
//            tools: ToolbarItems {
//                locked: tabletMode_PageTools
//            }


            Layouts {
                width: parent.width
                height: parent.height

                layouts: [
                    //ConditionalLayout with list of all countries ( phone mode )
                    // onclicked on any list item countryViewPhone will be presented
                    ConditionalLayout {
                        name: "phone"
                        when: appMode == "phone"
                        Column {
                            spacing: units.gu(1)
                            anchors {
                                margins: units.gu(2)
                                fill: parent
                            }
                            // search box for searching specyfic country
                            ItemLayout {
                                item: "searchBox"
                                width: parent.width
                                height: units.gu(4)
                            }
                            // list with all countries
                            ItemLayout {
                                item: "countryMainList"
                                width: parent.width
                                height: parent.height - text_field.height
                            }
                        }
                    },
                    //ConditionalLayout with list of all countries on the left and loaded
                    // country details on the right
                    // tablet mode
                    ConditionalLayout {
                        name: "tablet"
                        when: appMode == "tablet"
                        Row {
                            // left column in tablet mode with list of all countries and serachBox
                            Item {
                                height: byLocationPage.height
                                width: byLocationPage.width / 3
                                Behavior on width {
                                    UbuntuNumberAnimation {
                                        duration: UbuntuAnimation.BriskDuration
                                    }
                                }
                                Column {
                                    spacing: units.gu(1)
                                    width: parent.width/3
                                    anchors {
                                        margins: units.gu(2)
                                        fill: parent
                                    }
                                    // search box for searching specyfic country
                                    ItemLayout {
                                        item: "searchBox"
                                        width: parent.width
                                        height: units.gu(4)
                                    }
                                    // list with all the countiries
                                    ItemLayout {
                                        item: "countryMainList"
                                        width: parent.width
                                        height: parent.height - text_field.height
                                    }
                                }
                            }
                            // Seperator between countryList and countryPreview ( tablet mode )
                            Item {
                                width: units.gu(1)
                                height: byLocationPage.height
                                Rectangle {
                                    anchors.fill: parent
                                    color: "black"
                                    opacity: 0.2
                                }
                            }
                            // Country preview on the rght side ( tablet mode )
                            Item {
                                width: (parent.width / 3)*2 -units.gu(1)
                                height: byLocationPage.height
                                // countryView for tablet
                                CountryViewTabletDelegate {
                                    anchors.fill: parent
                                    country_flag_src: countryPreviewArray[0]
                                    country_map_src: countryPreviewArray[1]
                                    country_name: countryPreviewArray[2]
                                    country_frequency: countryPreviewArray[3]
                                    country_voltage: countryPreviewArray[4]
                                    country_plugs: countryPreviewArray[5]

                                }
                            }
                        }



                    }

                ]
                // search box for searching specyfic country
                TextField {
                    id: text_field
                    Layouts.item: "searchBox"
                    placeholderText: i18n.tr("Search")
                    onTextChanged: {
                        country_search(text)
                    }
                }

                // ListView with all countries for use in tablet and phone mode
                ListView {
                    Layouts.item: "countryMainList"
                    model: jsonMainDB.model
                    clip: true
                    delegate: ListItem.SingleValue {
                        text: '<font color="#003355">'+location+"</font></b>"
                        height: units.gu(5)
                        // this needs more work on updating listView.
                        progression: {
                            if(appMode == "tablet") {
                                progression = false
                            } else {
                                progression = true
                            }
                        }
                        value: if(plug.value.length > 1){value = plug.value.length + " " + i18n.tr("Plugs")} else { value = plug.value.length + " " + i18n.tr("Plug") }
                        icon: Qt.resolvedUrl("../img/flags/"+countryCode+".png")
//                        iconSource: Qt.resolvedUrl("../img/flags/"+countryCode+".png")
                        iconFrame: false


                        onClicked: {
//                            soundEffect_click.play()
                            if(appMode == "phone"){
                                pagestack.push(countryViewPhone)
                            }
                            countryPreviewArray_filler(index)// filling array with details
                        }

                    }
                    section.property: "location"
                    section.criteria: ViewSection.FirstCharacter
                    section.delegate: ListItem.Header { text: section }
                }
            }
        }

        // CountryViewPage, page for phone mode. presents selected country with all details.
        CountryViewPage {
            id: countryViewPhone
            visible: false
            country_flag_src: countryPreviewArray[0]
            country_map_src: countryPreviewArray[1]
            country_name: countryPreviewArray[2]
            country_frequency: countryPreviewArray[3]
            country_voltage: countryPreviewArray[4]
            country_plugs: countryPreviewArray[5]
        }


    }


    //Preview for Plugs and Sockets
    // it might get changed to ubuntu sheet component
    property alias plug_preview_src: plugPreviewImage.source
    property alias plug_preview_label: plugPreviewLabel.text
    UbuntuShape {
        id: plugPreview
        width: preview_width
        height: preview_heigth
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(1)

        color: "#ffcc55"
        visible: false
        opacity: 0
        // animation on opacity
        Behavior on opacity {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.SlowDuration
            }
        }
        // animation on width
        Behavior on width {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.BriskDuration
            }
        }
        // animation on height
        Behavior on height {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.BriskDuration
            }
        }

        // when width is less then gu5 hide this object. without it animation looks bad :D
        onWidthChanged: if(width < units.gu(5)){
                            visible = false
                        } else {
                            visible = true
                        }

        // to prevent user from clicking behind this preview.
        MouseArea {
            width: mainView.width
            height: mainView.height
        }

        Column {
            anchors.fill: parent
            spacing: units.gu(2)
            anchors.margins: units.gu(2)
            // label in the left cornenr of the preview.
            Label {
                id: plugPreviewLabel
                color: UbuntuColors.coolGrey
                fontSize: "large"
                text: "A" // this text have to be here in order prevent from getting error on app start!
            }

            // large image of the plug
            Image {
                id: plugPreviewImage
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                width: parent.height - units.gu(30)
            }

            // fake spacer, silly I know :D
            Button {
                // Button user as a "spacer"
                height: units.gu(4)
                opacity: 0
            }

            // ListView with all different plug and socket pictures so user can change without going back
            //to previous view
            ListView {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: units.gu(17)
                spacing: units.gu(2)
                clip: true
                model: plugImagesDetailsMODEL
                orientation: ListView.Horizontal
                delegate: CategoryDelegate {
                    width: units.gu(8)
                    height: units.gu(8)
                    //                            label: image
                    thumbnail: Qt.resolvedUrl("../img/plugs/%.png").arg(plugPreviewLabel.text.charAt(plugPreviewLabel.text.length-1)+view)
                    onClick: {
//                        soundEffect_click.play()
                        plug_preview_src = Qt.resolvedUrl("../img/plugs/%.png").arg(plugPreviewLabel.text.charAt(plugPreviewLabel.text.length-1)+view)
                        plug_preview_label = slicingStringForPlugPrevie(plugPreviewLabel.text.charAt(plugPreviewLabel.text.length-1), view)
                    }
                }
            }
        }

        // Close button
        Button {
            text: i18n.tr("<b>Close preview</b>")
            width: parent.width - units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(2)
            color: UbuntuColors.lightAubergine
            onClicked: {
//                soundEffect_click.play()
                parent.opacity = 0
                parent.width = 0
                parent.height = 0
            }
        }
    }
}
