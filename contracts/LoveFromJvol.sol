// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract FromJvol is ERC721,  ERC721Enumerable,Ownable {
    mapping(uint256 => string) internal _ipfs;
    string internal _lambdaURI;

    constructor() ERC721("<3FromJvol", "<3JVL") {}

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "<3 From Jvol - ',
                                uint2str(_tokenId),
                                '", "description": "Thank You <3", "image": "',
                                _getImageURI(_tokenId),
                                '"  }'
                            )
                        )
                    )
                )
            );
    }

    function Donate() public payable {

        payable(owner()).transfer(msg.value);
        uint _tokenid = _generateId();
        _safeMint(msg.sender , _tokenid);
    }


    function setLambda(string memory _uri) external onlyOwner {
        _lambdaURI = _uri;
    }

    function setIPFS(uint256 _tokenid, string memory _uri) external onlyOwner {
        _ipfs[_tokenid] = _uri;
    }

    function _getImageURI(uint256 _tokenId)
        internal
        view
        returns (string memory)
    {
        if (bytes(_ipfs[_tokenId]).length == 0) {
            return
                string(
                    abi.encodePacked(_lambdaURI, uint2str(_tokenId), ".png")
                );
        } else {
            return _ipfs[_tokenId];
        }
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }
    function safeMintRandom(address to) public onlyOwner {
        uint tokenId = _generateId();
        _safeMint(to, tokenId);
    }

    function _generateId() internal view returns (uint256 _tokenid) {

        uint256 randomKeccak = uint256(
            keccak256(
                abi.encodePacked(
                    totalSupply(),
                    msg.sender,
                    block.difficulty,
                    block.timestamp,
                    block.number
                )
            )
        );
        uint8 mask;
        uint8 pat;
        uint8 rev;
        uint8 r;
        uint8 g;
        uint8 b;
        uint16 strike;
        uint16 len;

        mask = uint8(randomKeccak % 8);
        pat = uint8(randomKeccak % 19);
        rev = uint8(randomKeccak % 3);
        r = uint8(randomKeccak % 255);
        g = uint8((randomKeccak / 255) % 255);
        b = uint8((randomKeccak / 255 / 255) % 255);
        strike = uint16((randomKeccak / 700) % 700);
        len = uint16(randomKeccak % 700);
       _tokenid = uint256(encodeLove(mask, pat, rev, r, g, b, strike, len));



    }


    function encodeLove(
        uint8 mask,
        uint8 pat,
        uint8 rev,
        uint8 r,
        uint8 g,
        uint8 b,
        uint16 hlstrike,
        uint16 hllen
    ) internal pure returns (bytes32 x) {
        assembly {
            mstore(0xa, hllen)
            mstore(0x8, hlstrike)
            mstore(0x6, b)
            mstore(0x5, g)
            mstore(0x4, r)
            mstore(0x3, rev)
            mstore(0x2, pat)
            mstore(0x1, mask)
            x := mload(0xa)
        }
    }



    // @title Base64
    // @author Brecht Devos - <brecht@loopring.org>
    // @notice Provides a function for encoding some bytes in base64
    function encode(bytes memory data) internal pure returns (string memory) {
        string
            memory TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)

                // read 3 bytes
                let input := mload(dataPtr)

                // write 4 characters
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(input, 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
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
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
