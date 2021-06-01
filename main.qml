import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import Dialpad 1.0

Window {
    width: 320
    height: 380
    visible: true
    title: qsTr("Dialpad")

    property int numberOfMessages: 0

    Image {
        anchors.fill: parent
        horizontalAlignment: Image.AlignHCenter
        source: "qrc:/resources/bgd_roster_gradient.png"
        rotation: -180
        clip: false
        mirror: false
        fillMode: Image.Tile
    }

    Image {
        x: 2000
        anchors.fill: parent
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignBottom
        fillMode: Image.Tile
        source: "qrc:/resources/bgd_bubbles.png"
        mirror: false
    }

    CountriesPrefixListModel {
        id: countriesModel
    }

    Component {
        id: countriesPrefixDelegate

        Item {
            width: ListView.view.width - 1
            height: 30

            Row {
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 8
                spacing: 5
                Image {
                    id: name
                    source: "qrc:/resources/countries/flags/"+ model.flag +".jpg"
                }

                Text {
                    text: model.countryName
                }
            }

            Text {
                text: "+" + model.prefix
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    dropDownFrame.enabled = false
                    dropDownFrame.opacity = 0
                    flagImage.source = "qrc:/resources/countries/flags/"+ model.flag +".jpg"
                    numberInput.text = "+" + model.prefix + numberInput.text
                }
            }
        }

    }


    Column {
        id: column
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        RowLayout {
            id: row1
            width: parent.width

            Text {
                color: "#000000"
                text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Credit: <span style=\" color:#1578fb;\">$0.00</span></p></body></html>"
                font.pointSize: 10
                textFormat: Text.RichText
            }

            Text {
                width: 100
                color: "#1578fb"
                text: "Buy credit"
                font.pointSize: 10
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
        }

        RowLayout {
            id: row2
            height: 30
            width: parent.width
            z:3

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Rectangle{
                    id: dropDownFrame
                    width: 250
                    height: 200
                    z:4
                    enabled: false
                    opacity: 0;
                    border.color: "lightgray"

                    ListView {
                        id: countriesPrefixList
                        width: parent.width - 1
                        height: parent.height - 2
                        x: 1
                        y: 1

                        enabled: dropDownFrame.enabled
                        opacity: dropDownFrame.opacity;

                        spacing: 2
                        clip: true

                        ScrollBar.vertical: ScrollBar{}

                        model: countriesModel

                        highlight: Rectangle {
                            width: ListView.view.width
                            height: countriesPrefixDelegate.height
                            color: "lightgray"
                        }

                        delegate: countriesPrefixDelegate
                    }
                }
            }

            Image {
                id: numberInputBackground
                Layout.fillWidth: true
                Layout.fillHeight: true
                fillMode: Image.Stretch
                z: -1
                source: "qrc:/resources/field_normal.png"


                Button {
                    id: dropDown
                    anchors.left: parent.left
                    flat: true
                    width: 53
                    height: parent.height
                    anchors.leftMargin: 4

                    Image {
                        id: flagImage
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 4
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 4
                        source: "qrc:/resources/combo_arrow.png"
                    }

                    onClicked: {
                        dropDownFrame.enabled = true
                        dropDownFrame.opacity = 1
                        numberInput.text = ""
                        countriesPrefixList.focus = true
                    }
                }

                TextArea {
                    id: numberInput
                    anchors.left: dropDown.right
                    width: parent.width - dropDown.width
                    height: parent.height

                    onTextChanged: {
                        var flagNumber = 0

                        if(numberInput.text.charAt(0) === '+')
                            flagNumber = countriesModel.checkPrefix(numberInput.text.slice(0,6))
                        else
                            flagNumber = countriesModel.checkPrefix(numberInput.text.slice(0,5))

                        if( flagNumber !== 0)
                            flagImage.source = "qrc:/resources/countries/flags/"+ flagNumber +".jpg"
                    }

                    onActiveFocusChanged: {
                        if (numberInput.focus)
                            numberInputBackground.source = "qrc:/resources/field_focus.png"
                        else
                            numberInputBackground.source = "qrc:/resources/field_normal.png"
                    }
                }
            }

            Rectangle {
                id: sendButton
                width: 70
                height: parent.height
                z: -1

                Image {
                    id: sendButtonImage
                    width: parent.width
                    height: parent.height
                    fillMode: Image.Stretch
                    source: "qrc:/resources/btn_white_normal.png"
                }

                Text {
                    anchors.centerIn: parent
                    text: "Send"
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        numberOfMessages++
                        messageText.clear()
                    }

                    onPressed: {
                        sendButtonImage.source = "qrc:/resources/btn_white_down.png"
                    }

                    onReleased: {
                        sendButtonImage.source = "qrc:/resources/btn_white_normal.png"
                    }

                    onEntered: {
                        sendButtonImage.source = "qrc:/resources/btn_white_hover.png"
                    }
                }
            }
        }

        TextField {
            id: messageText
            width: parent.width
            height: parent.height - row1.height - row2.height - row3.height - charactersLeftText.height - 32
            wrapMode: Text.WordWrap
            maximumLength: 160
            verticalAlignment: "AlignTop"
        }

        Text {
            id: charactersLeftText
            width: parent.width
            text: messageText.maximumLength - messageText.length + "/" + numberOfMessages.toString();
            horizontalAlignment: Text.AlignRight
            rightPadding: 4
            textFormat: Text.RichText

        }

        RowLayout{
            id: row3
            width: parent.width

            Image {
                source: "qrc:/resources/baseline_call_black_18dp.png"
                Layout.rightMargin: 8
                sourceSize.height: 24
                sourceSize.width: 24
                fillMode: Image.PreserveAspectFit
            }
            Text {
                color: "#ffffff"
                text: "Call"
                Layout.fillWidth: true
                font.pointSize: 10
            }

            Text {
                color: "#1578fb"
                text: "See rates"
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.pointSize: 10
            }
        }
    }
}
