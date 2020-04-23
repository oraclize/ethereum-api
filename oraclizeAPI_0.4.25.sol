// <ORACLIZE_API>
// Release targeted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
/*
Copyright (c) 2015-2016 Oraclize SRL
Copyright (c) 2016-2019 Oraclize LTD
Copyright (c) 2019 Provable Things Limited

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

// This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary

pragma solidity >= 0.4.22 < 0.5; // Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version

/**
 * @notice  A separate interface is used here for any queries that use type
 *          `bytes` to define the datasource due to the compiler not being able
 *          to differentiate the two function signatures if called via
 *          OraclizeI.query(...)
 *
 */
contract OraclizeIBytes {

    function queryN(uint _timestamp, bytes1 _datasource, bytes _argN) public payable returns (bytes32 _id);
    function query(uint _timestamp, bytes1 _datasource, string _arg) external payable returns (bytes32 _id);
    function query2(uint _timestamp, bytes1 _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
    function query_withGasLimit(uint _timestamp, bytes1 _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
    function queryN_withGasLimit(uint _timestamp, bytes1 _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
    function query2_withGasLimit(uint _timestamp, bytes1 _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);

}

contract OraclizeI {

    address public cbAddress;
    mapping (bytes32 => uint256) public price;
    mapping (address => address) public addressCustomPaymentToken;

    function unsetCustomTokenPayment() external;
    function setProofType(byte _proofType) external;
    function setCustomGasPrice(uint _gasPrice) external;
    function requestQueryCaching(bytes32 _queryId) external;
    function setCustomTokenPayment(address _tokenAddress) external;
    function queryCached() payable external returns (bytes32 _queryId);
    function getPrice(byte _datasource) public view returns (uint256 _dsprice);
    function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
    function getPrice(string memory _datasource) public view returns (uint256 _dsprice);
    function getPrice(byte _datasource, address _contractToQuery) public view returns (uint256 _dsprice);
    function getPrice(byte _datasource, uint256 _gasLimit) public view returns (uint256 _dsprice);
    function getPrice(string memory _datasource, address _contractToQuery) public view returns (uint256 _dsprice);
    function getPrice(string memory _datasource, uint256 _gasLimit) public view returns (uint256 _dsprice);
    function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
    function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
    function requestCallbackRebroadcast(bytes32 _queryId, uint256 _gasLimit, uint256 _gasPrice) payable external;
    function getPrice(byte _datasource, uint256 _gasLimit, address _contractToQuery) public view returns (uint256 _dsprice);
    function getRebroadcastCost(uint256 _gasLimit, uint256 _gasPrice) public pure returns (uint256 _rebroadcastCost);
    function convertToERC20Price(uint256 _queryPriceInWei, address _tokenAddress) public view returns (uint256 _price);
    function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
    function getPrice(string memory _datasource, uint256 _gasLimit, address _contractToQuery) public view returns (uint256 _dsprice);
    function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
    function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
    function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);

}

interface ERC20Interface {

    event Transfer(address indexed _from, address indexed _to, uint _tokens);
    event Approval(address indexed _tokenOwner, address indexed _spender, uint _tokens);

    function totalSupply() external view returns (uint);
    function transfer(address _to, uint _tokens) external returns (bool _success);
    function balanceOf(address _tokenOwner) external view returns (uint _balance);
    function approve(address _tokenSpender, uint256 _tokenAmount) external returns (bool);
    function transferFrom(address _from, address _to, uint _tokens) external returns (bool _success);
    function allowance(address _tokenOwner, address _spender) external view returns (uint _remaining);

}

contract OraclizeAddrResolverI {
    function getAddress() public returns (address _addr);
}

/*
Begin solidity-cborutils

https://github.com/smartcontractkit/solidity-cborutils

MIT License

Copyright (c) 2018 SmartContract ChainLink, Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

library Buffer {
    struct buffer {
        bytes buf;
        uint capacity;
    }

    function init(buffer memory buf, uint _capacity) internal pure {
        uint capacity = _capacity;
        if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
        // Allocate space for the buffer data
        buf.capacity = capacity;
        assembly {
            let ptr := mload(0x40)
            mstore(buf, ptr)
            mstore(ptr, 0)
            mstore(0x40, add(ptr, capacity))
        }
    }

    function resize(buffer memory buf, uint capacity) private pure {
        bytes memory oldbuf = buf.buf;
        init(buf, capacity);
        append(buf, oldbuf);
    }

    function max(uint a, uint b) private pure returns(uint) {
        if(a > b) {
            return a;
        }
        return b;
    }

    /**
     * @dev Appends a byte array to the end of the buffer. Resizes if doing so
     *      would exceed the capacity of the buffer.
     * @param buf The buffer to append to.
     * @param data The data to append.
     * @return The original buffer.
     */
    function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
        if(data.length + buf.buf.length > buf.capacity) {
            resize(buf, max(buf.capacity, data.length) * 2);
        }

        uint dest;
        uint src;
        uint len = data.length;
        assembly {
            // Memory address of the buffer data
            let bufptr := mload(buf)
            // Length of existing buffer data
            let buflen := mload(bufptr)
            // Start address = buffer address + buffer length + sizeof(buffer length)
            dest := add(add(bufptr, buflen), 32)
            // Update buffer length
            mstore(bufptr, add(buflen, mload(data)))
            src := add(data, 32)
        }

        // Copy word-length chunks while possible
        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }

        return buf;
    }

    /**
     * @dev Appends a byte to the end of the buffer. Resizes if doing so would
     * exceed the capacity of the buffer.
     * @param buf The buffer to append to.
     * @param data The data to append.
     * @return The original buffer.
     */
    function append(buffer memory buf, uint8 data) internal pure {
        if(buf.buf.length + 1 > buf.capacity) {
            resize(buf, buf.capacity * 2);
        }

        assembly {
            // Memory address of the buffer data
            let bufptr := mload(buf)
            // Length of existing buffer data
            let buflen := mload(bufptr)
            // Address = buffer address + buffer length + sizeof(buffer length)
            let dest := add(add(bufptr, buflen), 32)
            mstore8(dest, data)
            // Update buffer length
            mstore(bufptr, add(buflen, 1))
        }
    }

    /**
     * @dev Appends a byte to the end of the buffer. Resizes if doing so would
     * exceed the capacity of the buffer.
     * @param buf The buffer to append to.
     * @param data The data to append.
     * @return The original buffer.
     */
    function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
        if(len + buf.buf.length > buf.capacity) {
            resize(buf, max(buf.capacity, len) * 2);
        }

        uint mask = 256 ** len - 1;
        assembly {
            // Memory address of the buffer data
            let bufptr := mload(buf)
            // Length of existing buffer data
            let buflen := mload(bufptr)
            // Address = buffer address + buffer length + sizeof(buffer length) + len
            let dest := add(add(bufptr, buflen), len)
            mstore(dest, or(and(mload(dest), not(mask)), data))
            // Update buffer length
            mstore(bufptr, add(buflen, len))
        }
        return buf;
    }
}

library CBOR {
    using Buffer for Buffer.buffer;

    uint8 private constant MAJOR_TYPE_INT = 0;
    uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
    uint8 private constant MAJOR_TYPE_BYTES = 2;
    uint8 private constant MAJOR_TYPE_STRING = 3;
    uint8 private constant MAJOR_TYPE_ARRAY = 4;
    uint8 private constant MAJOR_TYPE_MAP = 5;
    uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;

    function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
        if(value <= 23) {
            buf.append(uint8((major << 5) | value));
        } else if(value <= 0xFF) {
            buf.append(uint8((major << 5) | 24));
            buf.appendInt(value, 1);
        } else if(value <= 0xFFFF) {
            buf.append(uint8((major << 5) | 25));
            buf.appendInt(value, 2);
        } else if(value <= 0xFFFFFFFF) {
            buf.append(uint8((major << 5) | 26));
            buf.appendInt(value, 4);
        } else if(value <= 0xFFFFFFFFFFFFFFFF) {
            buf.append(uint8((major << 5) | 27));
            buf.appendInt(value, 8);
        }
    }

    function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
        buf.append(uint8((major << 5) | 31));
    }

    function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
        encodeType(buf, MAJOR_TYPE_INT, value);
    }

    function encodeInt(Buffer.buffer memory buf, int value) internal pure {
        if(value >= 0) {
            encodeType(buf, MAJOR_TYPE_INT, uint(value));
        } else {
            encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
        }
    }

    function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
        encodeType(buf, MAJOR_TYPE_BYTES, value.length);
        buf.append(value);
    }

    function encodeString(Buffer.buffer memory buf, string value) internal pure {
        encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
        buf.append(bytes(value));
    }

    function startArray(Buffer.buffer memory buf) internal pure {
        encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
    }

    function startMap(Buffer.buffer memory buf) internal pure {
        encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
    }

    function endSequence(Buffer.buffer memory buf) internal pure {
        encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
    }
}

/*
End solidity-cborutils
 */

contract usingOraclize {
    uint constant day = 60 * 60 * 24;
    uint constant week = 60 * 60 * 24 * 7;
    uint constant month = 60 * 60 * 24 * 30;
    byte constant proofType_NONE = 0x00;
    byte constant proofType_TLSNotary = 0x10;
    byte constant proofType_Ledger = 0x30;
    byte constant proofType_Android = 0x40;
    byte constant proofType_Native = 0xF0;
    byte constant proofStorage_IPFS = 0x01;
    uint8 constant networkID_auto = 0;
    uint8 constant networkID_mainnet = 1;
    uint8 constant networkID_testnet = 2;
    uint8 constant networkID_morden = 2;
    uint8 constant networkID_consensys = 161;

    OraclizeAddrResolverI OAR;

    OraclizeI oraclize;
    OraclizeIBytes oraclizeBytes;

    modifier oraclizeAPI {
         if((address(OAR) == 0) || (getCodeSize(address(OAR)) == 0))
            oraclize_setNetwork(networkID_auto);

        address oraclizeConnector = OAR.getAddress();
        if(address(oraclize) != oraclizeConnector)
            oraclize = OraclizeI(oraclizeConnector);
            oraclizeBytes = OraclizeIBytes(address(oraclizeConnector));
        _;
    }

    modifier coupon(string code){
        oraclize = OraclizeI(OAR.getAddress());
        _;
    }

     function oraclize_setNetwork(uint8 networkID) internal returns(bool) {
        return oraclize_setNetwork();
        networkID; // silence the warning and remain backwards compatible
    }
     function oraclize_setNetwork() internal returns(bool) {
         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
            OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
            oraclize_setNetworkName("eth_mainnet");
            return true;
        }
        if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
            OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
            oraclize_setNetworkName("eth_ropsten3");
            return true;
        }
        if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
            OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
            oraclize_setNetworkName("eth_kovan");
            return true;
        }
        if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
            OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
            oraclize_setNetworkName("eth_rinkeby");
            return true;
        }
        if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41)>0){ //goerli testnet
            OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
            oraclize_setNetworkName("eth_goerli");
            return true;
        }
        if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
            OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
            return true;
        }
        if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
            OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
            return true;
        }
        if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
            OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
            return true;
        }
        return false;
    }
    /**
     * @dev The following `__callback` functions are just placeholders ideally
     *      meant to be defined in child contract when proofs are used.
     *      The function bodies simply silence compiler warnings.
     */
    function __callback(
        bytes32 myid,
        string result
    )
        public
    {
        __callback(myid, result, new bytes(0));
    }

    function __callback(
        bytes32 myid,
        string result,
        bytes proof
    )
        public
    {
      myid; result; proof;
      oraclize_randomDS_args[bytes32(0)] = bytes32(0);
    }
    /**
     *
     * @notice oraclize_getPrice(...) overloads follow...
     *
     */
    function oraclize_getPrice(
        string memory _datasource
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource);
    }

    function oraclize_getPrice(
        byte _datasource
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource);
    }

    function oraclize_getPrice(
        string memory _datasource,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource, _gasLimit);
    }

    function oraclize_getPrice(
        byte _datasource,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource, _gasLimit);
    }

    function oraclize_getPrice(
        string memory _datasource,
        address _contractToQuery
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource, _contractToQuery);
    }

    function oraclize_getPrice(
        byte _datasource,
        address _contractToQuery
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource, _contractToQuery);
    }

    function oraclize_getPrice(
        string memory _datasource,
        address _contractToQuery,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource, _gasLimit, _contractToQuery);
    }

    function oraclize_getPrice(
        byte _datasource,
        address _contractToQuery,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.getPrice(_datasource, _gasLimit, _contractToQuery);
    }

    function oraclize_getPrice(
        byte _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    proofType_NONE
                )
            )
        );
        return _queryPrice += _gasLimit * _gasPrice;
    }

    function oraclize_getPrice(
        byte _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        byte _proofType
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    _proofType
                )
            )
        );
        return _queryPrice += _gasLimit * _gasPrice;
    }

    function oraclize_getPrice(
        string memory _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    proofType_NONE
                )
            )
        );
        return _queryPrice += _gasLimit * _gasPrice;
    }

    function oraclize_getPrice(
        string memory _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        byte _proofType
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    _proofType
                )
            )
        );
        return _queryPrice += _gasLimit * _gasPrice;
    }
    /**
     *
     * @notice oraclize_getPriceERC20(...) overloads follow...
     *
     */
    function oraclize_getPriceERC20(
        string memory _datasource
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        address _tokenAddress,
        string memory _datasource
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        address _tokenAddress,
        byte _datasource
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        uint256 _gasLimit,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        uint256 _gasLimit,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        address _contractToQuery
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _contractToQuery),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        address _contractToQuery
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _contractToQuery),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        address _contractToQuery,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _contractToQuery),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        address _contractToQuery,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _contractToQuery),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        address _contractToQuery,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit, _contractToQuery),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        address _contractToQuery,
        uint256 _gasLimit
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit, _contractToQuery),
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        address _contractToQuery,
        uint256 _gasLimit,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit, _contractToQuery),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        address _contractToQuery,
        uint256 _gasLimit,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        return oraclize.convertToERC20Price(
            oraclize.getPrice(_datasource, _gasLimit, _contractToQuery),
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    proofType_NONE
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    proofType_NONE
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    proofType_NONE
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        byte _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        byte _proofType
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    _proofType
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    proofType_NONE
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        byte _proofType
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    _proofType
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            oraclize.addressCustomPaymentToken(address(this))
        );
    }

    function oraclize_getPriceERC20(
        string memory _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        byte _proofType,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    _proofType
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            _tokenAddress
        );
    }

    function oraclize_getPriceERC20(
        bytes1 _datasource,
        uint256 _gasLimit,
        uint256 _gasPrice,
        byte _proofType,
        address _tokenAddress
    )
        oraclizeAPI
        internal
        returns (uint256 _queryPrice)
    {
        _queryPrice = oraclize.price(
            keccak256(
                abi.encodePacked(
                    _datasource,
                    _proofType
                )
            )
        );
        return oraclize.convertToERC20Price(
            _queryPrice + _gasLimit * _gasPrice,
            _tokenAddress
        );
    }
    /**
     *
     * @notice `oraclize_query` overloads using the STRING datasource follow...
     *
     */
    function oraclize_query(
        string datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(0, datasource, arg);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(timestamp, datasource, arg);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(0, datasource, arg1, arg2);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN.value(price)(0, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN.value(price)(timestamp, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN.value(price)(0, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN.value(price)(timestamp, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
    }
    /**
     *
     * @notice `oraclize_query` overloads using the BYTE datasource follow...
     *
     */
    function oraclize_query(
        bytes1 datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query.value(price)(0, datasource, arg);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query.value(price)(timestamp, datasource, arg);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query2.value(price)(0, datasource, arg1, arg2);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query2.value(price)(timestamp, datasource, arg1, arg2);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN.value(price)(0, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN.value(price)(timestamp, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN.value(price)(0, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN.value(price)(timestamp, datasource, args);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
    }
    /**
     *
     * @notice  `oraclize_query` overloads using dynamic arguments and the
     *          STRING type datasource follow...
     *
     */
    function oraclize_query(
        string datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        string datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        string datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs, gaslimit);
    }
    /**
     *
     * @notice  `oraclize_query` overloads using dynamic arguments and the
     *          BYTES1 datasource type follow...
     *
     */
    function oraclize_query(
        bytes1 datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_query(datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs);
    }

    function oraclize_query(
        uint timestamp,
        bytes1 datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_query(
        bytes1 datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_query(datasource, dynargs, gaslimit);
    }
    /*
     *
     * @notice `oraclize_query` overloads end.
     *
     * @notice `oraclize_token_query` overloads using the STRING datasource follow...
     *
     */
    function oraclize_token_query(
        string datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query(0, datasource, arg);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query(timestamp, datasource, arg);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit(timestamp, datasource, arg, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit(0, datasource, arg, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query2(0, datasource, arg1, arg2);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclize.query2(timestamp, datasource, arg1, arg2);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit(timestamp, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit(0, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN(0, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN(timestamp, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN_withGasLimit(timestamp, datasource, args, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclize.queryN_withGasLimit(0, datasource, args, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN(0, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN(timestamp, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN_withGasLimit(timestamp, datasource, args, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclize.queryN_withGasLimit(0, datasource, args, gaslimit);
    }
    /**
     *
     * @notice `oraclize_token_query` overloads using the BYTE datasource follow...
     *
     */
    function oraclize_token_query(
        bytes1 datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query(0, datasource, arg);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string arg
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query(timestamp, datasource, arg);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query_withGasLimit(timestamp, datasource, arg, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string arg,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query_withGasLimit(0, datasource, arg, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query2(0, datasource, arg1, arg2);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string arg1,
        string arg2
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        return oraclizeBytes.query2(timestamp, datasource, arg1, arg2);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query2_withGasLimit(timestamp, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string arg1,
        string arg2,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        return oraclizeBytes.query2_withGasLimit(0, datasource, arg1, arg2, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN(0, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN(timestamp, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit(timestamp, datasource, args, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = stra2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit(0, datasource, args, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN(0, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[] argN
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN(timestamp, datasource, args);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit(timestamp, datasource, args, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[] argN,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
        bytes memory args = ba2cbor(argN);
        return oraclizeBytes.queryN_withGasLimit(0, datasource, args, gaslimit);
    }
    /**
     *
     * @notice  `oraclize_token_query` overloads using dynamic arguments and the
     *          STRING type datasource follow...
     *
     */
    function oraclize_token_query(
        string datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        string datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        string datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }
    /**
     *
     * @notice  `oraclize_token_query` overloads using dynamic arguments and the
     *          BYTES1 datasource type follow...
     *
     */
    function oraclize_token_query(
        bytes1 datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        string[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        string[] memory dynargs = new string[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[1] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[1] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](1);
        dynargs[0] = args[0];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[2] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[2] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](2);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[3] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[3] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](3);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[4] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[4] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](4);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[5] args
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs);
    }

    function oraclize_token_query(
        uint timestamp,
        bytes1 datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(timestamp, datasource, dynargs, gaslimit);
    }

    function oraclize_token_query(
        bytes1 datasource,
        bytes[5] args,
        uint gaslimit
    )
        oraclizeAPI
        internal
        returns (bytes32 id)
    {
        bytes[] memory dynargs = new bytes[](5);
        dynargs[0] = args[0];
        dynargs[1] = args[1];
        dynargs[2] = args[2];
        dynargs[3] = args[3];
        dynargs[4] = args[4];
        return oraclize_token_query(datasource, dynargs, gaslimit);
    }
    /*
     *
     * @notice `oraclize_token_query` overloads end.
     *
     */
    function oraclize_cbAddress()
        oraclizeAPI
        internal
        returns (address)
    {
        return oraclize.cbAddress();
    }

    function oraclize_setProof(byte proofP)
        oraclizeAPI
        internal
    {
        return oraclize.setProofType(proofP);
    }

    function oraclize_setCustomGasPrice(
        uint gasPrice
    )
        oraclizeAPI
        internal
    {
        return oraclize.setCustomGasPrice(gasPrice);
    }

    function oraclize_randomDS_getSessionPubKeyHash()
        oraclizeAPI
        internal
        returns (bytes32)
    {
        return oraclize.randomDS_getSessionPubKeyHash();
    }

    function getCodeSize(address _addr)
        internal
        view
        returns(uint _size)
    {
        assembly {
            _size := extcodesize(_addr)
        }
    }

    function oraclize_requestQueryCaching(bytes32 _queryId)
        oraclizeAPI
        internal
    {
        return oraclize.requestQueryCaching(_queryId);
    }

    function oraclize_queryCached(uint256 _queryPrice)
        oraclizeAPI
        internal
        returns (bytes32 _queryId)
    {
        return oraclize.queryCached.value(_queryPrice)();
    }

    function oraclize_getDatasourceByte(
        string memory _datasourceString
    )
        internal
        returns (byte _datasourceByte)
    {
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('URL'))
            return 0xFF;
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('Random'))
            return 0xFE;
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('computation'))
            return 0xFD;
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('WolframAlpha'))
            return 0xFC;
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('IPFS'))
            return 0xFB;
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('nested'))
            return 0xFA;
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('Blockchain'))
            return 0xF9;
        if (keccak256(abi.encodePacked(_datasourceString)) == keccak256('swarm'))
            return 0xF8;
        return 0x00;
    }

    function oraclize_getRebroadcastCost(
        uint256 _gasLimit,
        uint256 _gasPrice
    )
        oraclizeAPI
        internal
        returns (uint256 _rebroadcastCost)
    {
        return oraclize.getRebroadcastCost(
            _gasLimit,
            _gasPrice
        );
    }

    function oraclize_requestCallbackRebroadcast(
        bytes32 _queryId,
        uint256 _gasLimit,
        uint256 _gasPrice,
        uint256 _queryPrice
    )
        oraclizeAPI
        internal
    {
        return oraclize
            .requestCallbackRebroadcast
            .value(_queryPrice)
            (
                _queryId,
                _gasLimit,
                _gasPrice
            );
    }

    function oraclize_setCustomTokenPayment(address _tokenAddress)
        oraclizeAPI
        internal
    {
        return oraclize.setCustomTokenPayment(_tokenAddress);
    }

    function oraclize_approveTokenAllowance(
        address _tokenAddress,
        uint256 _tokenAmount
    )
        oraclizeAPI
        internal
    {
        ERC20Interface(_tokenAddress)
            .approve(address(oraclize), _tokenAmount);
    }

    function oraclize_setAndApproveCustomTokenPayment(
        address _tokenAddress,
        uint256 _tokenAmount
    )
       oraclizeAPI
       internal
    {
        oraclize_setCustomTokenPayment(_tokenAddress);
        oraclize_approveTokenAllowance(_tokenAddress, _tokenAmount);
    }

    function oraclize_unsetAndRevokeCustomTokenPayment(address _tokenAddress)
        oraclizeAPI
        internal
    {
        oraclize_unsetCustomTokenPayment();
        oraclize_approveTokenAllowance(_tokenAddress, 0);
    }

    function oraclize_unsetCustomTokenPayment()
        oraclizeAPI
        internal
    {
        return oraclize.unsetCustomTokenPayment();
    }
    /**
     *
     * @notice Oraclize helper functions follow.
     *
     */
    function parseAddr(string memory _a)
        internal
        pure
        returns (address _parsedAddress)
    {
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint256 i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(tmp[i]));
            b2 = uint160(uint8(tmp[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
        }
        return address(iaddr);
    }

    function strCompare(
        string memory _a,
        string memory _b
    )
        internal
        pure
        returns (int _returnCode)
    {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint256 minLength = a.length;
        if (b.length < minLength) {
            minLength = b.length;
        }
        for (uint256 i = 0; i < minLength; i ++) {
            if (a[i] < b[i]) {
                return -1;
            } else if (a[i] > b[i]) {
                return 1;
            }
        }
        if (a.length < b.length) {
            return -1;
        } else if (a.length > b.length) {
            return 1;
        } else {
            return 0;
        }
    }

    function indexOf(
        string memory _haystack,
        string memory _needle
    )
        internal
        pure
        returns (int _returnCode)
    {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
            return -1;
        } else if (h.length > (2 ** 128 - 1)) {
            return -1;
        } else {
            uint256 subindex = 0;
            for (uint256 i = 0; i < h.length; i++) {
                if (h[i] == n[0]) {
                    subindex = 1;
                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
                        subindex++;
                    }
                    if (subindex == n.length) {
                        return int(i);
                    }
                }
            }
            return -1;
        }
    }

    function strConcat(
        string memory _a,
        string memory _b
    )
        internal
        pure
        returns (string memory _concatenatedString)
    {
        return strConcat(_a, _b, "", "", "");
    }

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c
    )
        internal
        pure
        returns (string memory _concatenatedString)
    {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d
    )
        internal
        pure
        returns (string memory _concatenatedString)
    {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d,
        string memory _e
    )
        internal
        pure
        returns (string memory _concatenatedString)
    {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(
            _ba.length +
            _bb.length +
            _bc.length +
            _bd.length +
            _be.length
        );
        bytes memory babcde = bytes(abcde);
        uint256 k = 0;
        uint256 i = 0;
        for (i = 0; i < _ba.length; i++) {
            babcde[k++] = _ba[i];
        }
        for (i = 0; i < _bb.length; i++) {
            babcde[k++] = _bb[i];
        }
        for (i = 0; i < _bc.length; i++) {
            babcde[k++] = _bc[i];
        }
        for (i = 0; i < _bd.length; i++) {
            babcde[k++] = _bd[i];
        }
        for (i = 0; i < _be.length; i++) {
            babcde[k++] = _be[i];
        }
        return string(babcde);
    }

    function parseInt(string memory _a)
        internal
        pure
        returns (uint256 _parsedInt)
    {
        return parseInt(_a, 0);
    }

    function parseInt(
        string memory _a,
        uint256 _b
    )
        internal
        pure
        returns (uint256 _parsedInt)
    {
        bytes memory bresult = bytes(_a);
        uint256 mint = 0;
        bool decimals = false;
        for (uint256 i = 0; i < bresult.length; i++) {
            if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
                if (decimals) {
                   if (_b == 0) {
                       break;
                   } else {
                       _b--;
                   }
                }
                mint *= 10;
                mint += uint(uint8(bresult[i])) - 48;
            } else if (uint(uint8(bresult[i])) == 46) {
                decimals = true;
            }
        }
        if (_b > 0) {
            mint *= 10 ** _b;
        }
        return mint;
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    using CBOR for Buffer.buffer;

    function stra2cbor(string[] arr)
        internal
        pure
        returns (bytes)
    {
        safeMemoryCleaner();
        Buffer.buffer memory buf;
        Buffer.init(buf, 1024);
        buf.startArray();
        for (uint i = 0; i < arr.length; i++) {
            buf.encodeString(arr[i]);
        }
        buf.endSequence();
        return buf.buf;
    }

    function ba2cbor(bytes[] arr)
        internal
        pure
        returns (bytes)
    {
        safeMemoryCleaner();
        Buffer.buffer memory buf;
        Buffer.init(buf, 1024);
        buf.startArray();
        for (uint i = 0; i < arr.length; i++) {
            buf.encodeBytes(arr[i]);
        }
        buf.endSequence();
        return buf.buf;
    }

    string oraclize_network_name;

    function oraclize_setNetworkName(string _network_name)
        internal
    {
        oraclize_network_name = _network_name;
    }

    function oraclize_getNetworkName()
        internal
        view
        returns (string)
    {
        return oraclize_network_name;
    }

    function oraclize_newRandomDSQuery(
        uint256 _delay,
        uint256 _nbytes,
        uint256 _customGasLimit
    )
        internal
        returns (bytes32 _queryId)
    {
        require((_nbytes > 0) && (_nbytes <= 32));
        _delay *= 10; // Convert from seconds to ledger timer ticks
        bytes memory nbytes = new bytes(1);
        nbytes[0] = byte(uint8(_nbytes));
        bytes memory unonce = new bytes(32);
        bytes memory sessionKeyHash = new bytes(32);
        bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
        assembly {
            mstore(unonce, 0x20)
            /*
             The following variables can be relaxed.
             Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
             for an idea on how to override and replace commit hash variables.
            */
            mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
            mstore(sessionKeyHash, 0x20)
            mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
        }
        bytes memory delay = new bytes(32);
        assembly {
            mstore(add(delay, 0x20), _delay)
        }
        bytes memory delay_bytes8 = new bytes(8);
        copyBytes(delay, 24, 8, delay_bytes8, 0);
        bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
        bytes32 queryId = oraclize_query("random", args, _customGasLimit);
        bytes memory delay_bytes8_left = new bytes(8);
        assembly {
            let x := mload(add(delay_bytes8, 0x20))
            mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
            mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
            mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
            mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
            mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
            mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
            mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
            mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
        }
        oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
        return queryId;
    }

    function oraclize_randomDS_setCommitment(
        bytes32 queryId,
        bytes32 commitment
    )
        internal
    {
        oraclize_randomDS_args[queryId] = commitment;
    }

    mapping(bytes32 => bytes32) oraclize_randomDS_args;
    mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;

    function verifySig(
        bytes32 tosignh,
        bytes dersig,
        bytes pubkey
    )
        internal
        returns (bool)
    {
        bool sigok;
        address signer;

        bytes32 sigr;
        bytes32 sigs;

        bytes memory sigr_ = new bytes(32);
        uint offset = 4+(uint(dersig[3]) - 0x20);
        sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
        bytes memory sigs_ = new bytes(32);
        offset += 32 + 2;
        sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);

        assembly {
            sigr := mload(add(sigr_, 32))
            sigs := mload(add(sigs_, 32))
        }


        (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
        if (address(keccak256(pubkey)) == signer) return true;
        else {
            (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
            return (address(keccak256(pubkey)) == signer);
        }
    }

    function oraclize_randomDS_proofVerify__sessionKeyValidity(
        bytes proof,
        uint sig2offset
    )
        internal
        returns (bool)
    {
        bool sigok;

        // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
        bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
        copyBytes(proof, sig2offset, sig2.length, sig2, 0);

        bytes memory appkey1_pubkey = new bytes(64);
        copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);

        bytes memory tosign2 = new bytes(1+65+32);
        tosign2[0] = byte(1); //role
        copyBytes(proof, sig2offset-65, 65, tosign2, 1);
        bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
        copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
        sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);

        if (sigok == false) return false;


        // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
        bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";

        bytes memory tosign3 = new bytes(1+65);
        tosign3[0] = 0xFE;
        copyBytes(proof, 3, 65, tosign3, 1);

        bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
        copyBytes(proof, 3+65, sig3.length, sig3, 0);

        sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);

        return sigok;
    }

    modifier oraclize_randomDS_proofVerify(
        bytes32 _queryId,
        string _result,
        bytes _proof)
    {
        // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
        require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));

        bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
        require(proofVerified);

        _;
    }

    function oraclize_randomDS_proofVerify__returnCode(
        bytes32 _queryId,
        string memory _result,
        bytes memory _proof
    )
        internal
        returns (uint8 _returnCode)
    {
        // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
        if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
            return 1;
        }
        bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
        if (!proofVerified) {
            return 2;
        }
        return 0;
    }

    function matchBytes32Prefix(
        bytes32 _content,
        bytes memory _prefix,
        uint256 _nRandomBytes
    )
        internal
        pure
        returns (bool _matchesPrefix)
    {
        bool match_ = true;
        require(_prefix.length == _nRandomBytes);
        for (uint256 i = 0; i < _nRandomBytes; i++) {
            if (_content[i] != _prefix[i]) {
                match_ = false;
            }
        }
        return match_;
    }

    function oraclize_randomDS_proofVerify__main(
        bytes memory _proof,
        bytes32 _queryId,
        bytes memory _result,
        string memory _contextName
    )
        internal
        returns (bool _proofVerified)
    {
        // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
        uint256 ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
        bytes memory keyhash = new bytes(32);
        copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
        if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
            return false;
        }
        bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
        copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
        // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
        if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
            return false;
        }
        // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
        // This is to verify that the computed args match with the ones specified in the query.
        bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
        copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
        bytes memory sessionPubkey = new bytes(64);
        uint256 sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
        copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
        bytes32 sessionPubkeyHash = sha256(sessionPubkey);
        if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
            delete oraclize_randomDS_args[_queryId];
        } else return false;
        // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
        bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
        copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
        if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
            return false;
        }
        // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
        if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
            oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
        }
        return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
    }

    // the following function has been written by Alex Beregszaszi (axic), use it under the terms of the MIT license
    function copyBytes(
        bytes from,
        uint fromOffset,
        uint length,
        bytes to,
        uint toOffset
    )
        internal
        pure
        returns (bytes)
    {
        uint minLength = length + toOffset;

        // Buffer too small
        require(to.length >= minLength); // Should be a better way?

        // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
        uint i = 32 + fromOffset;
        uint j = 32 + toOffset;

        while (i < (32 + fromOffset + length)) {
            assembly {
                let tmp := mload(add(from, i))
                mstore(add(to, j), tmp)
            }
            i += 32;
            j += 32;
        }

        return to;
    }

    // the following function has been written by Alex Beregszaszi (axic), use it under the terms of the MIT license
    // Duplicate Solidity's ecrecover, but catching the CALL return value
    function safer_ecrecover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        internal
        returns (bool, address)
    {
        // We do our own memory management here. Solidity uses memory offset
        // 0x40 to store the current end of memory. We write past it (as
        // writes are memory extensions), but don't update the offset so
        // Solidity will reuse it. The memory used here is only needed for
        // this context.

        // FIXME: inline assembly can't access return values
        bool ret;
        address addr;

        assembly {
            let size := mload(0x40)
            mstore(size, hash)
            mstore(add(size, 32), v)
            mstore(add(size, 64), r)
            mstore(add(size, 96), s)

            // NOTE: we can reuse the request memory because we deal with
            //       the return code
            ret := call(3000, 1, 0, size, 128, size, 32)
            addr := mload(size)
        }

        return (ret, addr);
    }
    // the following function has been written by Alex Beregszaszi (axic), use it under the terms of the MIT license
    function ecrecovery(
        bytes32 hash,
        bytes sig
    )
        internal
        returns (bool, address)
    {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (sig.length != 65)
            return (false, 0);

        // The signature format is a compact form of:
        //   {bytes32 r}{bytes32 s}{uint8 v}
        // Compact means, uint8 is not padded to 32 bytes.
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))

            // Here we are loading the last 32 bytes. We exploit the fact that
            // 'mload' will pad with zeroes if we overread.
            // There is no 'mload8' to do this, but that would be nicer.
            v := byte(0, mload(add(sig, 96)))

            // Alternative solution:
            // 'byte' is not working due to the Solidity parser, so lets
            // use the second best option, 'and'
            // v := and(mload(add(sig, 65)), 255)
        }

        // albeit non-transactional signatures are not specified by the YP, one would expect it
        // to match the YP range of [27, 28]
        //
        // geth uses [0, 1] and some clients have followed. This might change, see:
        //  https://github.com/ethereum/go-ethereum/issues/2053
        if (v < 27)
            v += 27;

        if (v != 27 && v != 28)
            return (false, 0);

        return safer_ecrecover(hash, v, r, s);
    }

    function safeMemoryCleaner()
        internal
        pure
    {
        assembly {
            let fmem := mload(0x40)
            codecopy(fmem, codesize, sub(msize, fmem))
        }
    }
}
// </ORACLIZE_API>
