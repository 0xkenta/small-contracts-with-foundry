pragma solidity  0.8.13;

import '@openzeppelin/contracts/utils/Base64.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '../TryDynamicNFT.sol';

library Descriptor {
    using Strings for uint8;

    struct TokenURIParams {
        string id;
        string name;
        string description;
        string title;
        string artist;
        TryDynamicNFT.Status status;
    }

    function constructTokenURI(TokenURIParams memory _params) public pure returns (string memory) {
        string memory image = generateSVGImage(_params);
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked('{"name":"', _params.name, '", "description":"', _params.description, '", "image": "', 'data:image/svg+xml;base64,', image, '"}')
                    )
                )
            )
        );
    }

    function generateSVGImage(TokenURIParams memory _params) public pure returns (string memory) {
        return Base64.encode(bytes(
            string(
                abi.encodePacked(
                    '<svg width="320" height="320" viewBox="0 0 320 320" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges">',
                    '<rect width="100%" height="100%" />',
                    _getSVGTextContent(_params),
                    '</svg>'
                )
            )
        ));
    }

    function _getSVGTextContent(TokenURIParams memory _params) private pure returns (bytes memory) {
        string memory _status =
            _params.status == TryDynamicNFT.Status.notStarted ? "Not Started"
            : _params.status == TryDynamicNFT.Status.started ? "Started"
            : _params.status == TryDynamicNFT.Status.finished ? "Finished" : "";

        string memory tokenId = string(abi.encodePacked('Id: ', _params.id));
        string memory title = string(abi.encodePacked('Title: ', _params.title));
        string memory artist = string(abi.encodePacked('Artist: ', _params.artist));
        string memory status = string(abi.encodePacked('Status: ', _status));

        return abi.encodePacked(
            _getSVGTextTag(tokenId, 20),
            _getSVGTextTag(title, 40),
            _getSVGTextTag(artist, 60),
            _getSVGTextTag(status, 80)
        );
    }

    function _getSVGTextTag(string memory _child, uint8 _y) private pure returns(bytes memory) {
        return abi.encodePacked(
            '<text x="0" y="', _y.toString(), '" fill="white">',
            _child,
            '</text>'
        );
    }
}