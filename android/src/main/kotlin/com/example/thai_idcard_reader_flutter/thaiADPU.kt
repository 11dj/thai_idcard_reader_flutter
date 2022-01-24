package com.example.thai_idcard_reader_flutter

import com.acs.smartcard.Reader
import java.io.ByteArrayOutputStream
import java.nio.charset.Charset

class ThaiADPU {
        val select =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xA4.toByte(),
                                        0x04.toByte(),
                                        0x00.toByte(),
                                        0x08.toByte(),
                                        0xA0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x54.toByte(),
                                        0x48.toByte(),
                                        0x00.toByte(),
                                        0x01.toByte()
                        )

        var cid =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x00.toByte(),
                                        0x04.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x0D.toByte()
                        )
        var cidGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x0D.toByte()
                        )

        val nameTH =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x00.toByte(),
                                        0x11.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )
        val nameTHGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )

        val nameEN =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x00.toByte(),
                                        0x75.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )
        val nameENGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )

        val birthdate =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x00.toByte(),
                                        0xD9.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x08.toByte()
                        )
        val birthdateGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x08.toByte()
                        )

        val gender =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x00.toByte(),
                                        0xE1.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x01.toByte()
                        )
        val genderGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x01.toByte()
                        )

        val address =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x15.toByte(),
                                        0x79.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )
        val addressGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )

        val cardIssuer =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x01.toByte(),
                                        0xF6.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )
        val cardIssuerGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x64.toByte()
                        )

        val issueDate =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x01.toByte(),
                                        0x67.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x08.toByte()
                        )
        val issueDateGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x08.toByte()
                        )

        val expireDate =
                        byteArrayOf(
                                        0x80.toByte(),
                                        0xB0.toByte(),
                                        0x01.toByte(),
                                        0x6F.toByte(),
                                        0x02.toByte(),
                                        0x00.toByte(),
                                        0x08.toByte()
                        )
        val expireDateGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0x08.toByte()
                        )

        val photo =
                        arrayOf(
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x01.toByte(),
                                                        0x7B.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x02.toByte(),
                                                        0x7A.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x03.toByte(),
                                                        0x79.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x04.toByte(),
                                                        0x78.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x05.toByte(),
                                                        0x77.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x06.toByte(),
                                                        0x76.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x07.toByte(),
                                                        0x75.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x08.toByte(),
                                                        0x74.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x09.toByte(),
                                                        0x73.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x0A.toByte(),
                                                        0x72.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x0B.toByte(),
                                                        0x71.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x0C.toByte(),
                                                        0x70.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x0D.toByte(),
                                                        0x6F.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x0E.toByte(),
                                                        0x6E.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x0F.toByte(),
                                                        0x6D.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x10.toByte(),
                                                        0x6C.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x11.toByte(),
                                                        0x6B.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x12.toByte(),
                                                        0x6A.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x13.toByte(),
                                                        0x69.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        ),
                                        byteArrayOf(
                                                        0x80.toByte(),
                                                        0xB0.toByte(),
                                                        0x14.toByte(),
                                                        0x68.toByte(),
                                                        0x02.toByte(),
                                                        0x00.toByte(),
                                                        0xFF.toByte()
                                        )
                        )

        val photoGetdata =
                        byteArrayOf(
                                        0x00.toByte(),
                                        0xC0.toByte(),
                                        0x00.toByte(),
                                        0x00.toByte(),
                                        0xFF.toByte()
                        )

        val allDataList: Array<String> =
                        arrayOf(
                                        "cid",
                                        "nameTH",
                                        "nameEN",
                                        "birthdate",
                                        "gender",
                                        "address",
                                        "cardIssuer",
                                        "issueDate",
                                        "expireDate",
                                        "photo"
                        )

        fun readAll(r: Reader): HashMap<String, Any> {
                return readSpecific(r, allDataList)
        }

        fun readSpecific(r: Reader, reqList: Array<String>): HashMap<String, Any> {
                val response = HashMap<String, Any>()
                val respArray = ByteArray(500)
                var responsLength: Int
                var slotNum = 0
                resetCard(r)
                setProtocol(r)
                if ("cid" in reqList) {
                        r.transmit(slotNum, cid, cid.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        cidGetdata,
                                                        cidGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("cid", it)
                        }
                }
                if ("nameTH" in reqList) {
                        r.transmit(slotNum, nameTH, nameTH.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        nameTHGetdata,
                                                        nameTHGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("nameTH", it)
                        }
                }
                if ("nameEN" in reqList) {
                        r.transmit(slotNum, nameEN, nameEN.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        nameENGetdata,
                                                        nameENGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("nameEN", it)
                        }
                }
                if ("birthdate" in reqList) {
                        r.transmit(slotNum, birthdate, birthdate.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        birthdateGetdata,
                                                        birthdateGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("birthdate", it)
                        }
                }
                if ("gender" in reqList) {
                        r.transmit(slotNum, gender, gender.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        genderGetdata,
                                                        genderGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("gender", it)
                        }
                }
                if ("address" in reqList) {
                        r.transmit(slotNum, address, address.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        addressGetdata,
                                                        addressGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("address", it)
                        }
                }
                if ("cardIssuer" in reqList) {
                        r.transmit(slotNum, cardIssuer, cardIssuer.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        cardIssuerGetdata,
                                                        cardIssuerGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("cardIssuer", it)
                        }
                }
                if ("issueDate" in reqList) {
                        r.transmit(slotNum, issueDate, issueDate.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        issueDateGetdata,
                                                        issueDateGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("issueDate", it)
                        }
                }
                if ("expireDate" in reqList) {
                        r.transmit(slotNum, expireDate, expireDate.size, respArray, respArray.size)
                        responsLength =
                                        r.transmit(
                                                        slotNum,
                                                        expireDateGetdata,
                                                        expireDateGetdata.size,
                                                        respArray,
                                                        respArray.size
                                        )
                        byteArrayToHexString(respArray, 0, responsLength)?.let {
                                response.put("expireDate", it)
                        }
                }
                if ("photo" in reqList) {
                        val buffer = ByteArrayOutputStream()
                        for (i in photo.indices) {
                                r.transmit(
                                                slotNum,
                                                photo[i],
                                                photo[i].size,
                                                respArray,
                                                respArray.size
                                )
                                responsLength =
                                                r.transmit(
                                                                slotNum,
                                                                photoGetdata,
                                                                photoGetdata.size,
                                                                respArray,
                                                                respArray.size
                                                )
                                buffer.write(respArray, 0, responsLength - 2)
                        }
                        val photoBuffer: ByteArray = buffer.toByteArray()
                        response["pictureBuffer"] = photoBuffer
                }
                return response
        }

        private fun resetCard(r: Reader) {
                r.power(0, Reader.CARD_WARM_RESET)
        }
        private fun setProtocol(r: Reader) {
                r.setProtocol(0, Reader.PROTOCOL_T0)
                val response = ByteArray(300)
                r.transmit(0, select, select.size, response, response.size)
        }

        private fun byteArrayToHexString(input: ByteArray, index: Int, length: Int): String? {
                var length = length
                if (length + index > input.size) {
                        length = input.size - index
                }
                val selectBytes: ByteArray = ByteArray(length)
                System.arraycopy(input, index, selectBytes, 0, length - 2)
                return showByteString(selectBytes)
        }

        private fun showByteString(input: ByteArray?): String? {
                val output: StringBuilder = StringBuilder()
                for (b in input!!) {
                        output.append(String.format("%02x", b))
                }
                var result: String? = null
                result = input.toString(Charset.forName("TIS620"))
                return result
        }
}
