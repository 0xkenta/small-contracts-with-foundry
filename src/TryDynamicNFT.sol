pragma solidity  0.8.13;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import './libraries/Descriptor.sol';

contract TryDynamicNFT is ERC721 {
    using Strings for uint256;

    enum Status {
        notStarted,
        started,
        finished
    }

    struct Info {
        string title;
        string artist;
        Status status;
    }

    uint256 private nextId = 1;

    mapping (uint256 => Info) private infos;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mint(address _to, string calldata _title, string calldata _artist) external returns (uint256) {
        uint256 tokenId = nextId;

        infos[tokenId].title = _title;
        infos[tokenId].artist = _artist;
        infos[tokenId].status = Status.notStarted;

        _mint(_to, tokenId);

        nextId++;

        return tokenId;
    }

    function getInfo(uint256 _tokenId) external view returns (string memory, string memory, Status) {
        Info storage info = infos[_tokenId];
        return (info.title, info.artist, info.status);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "NOT EXIST");
        return dataURI(_tokenId);
    }

    function dataURI(uint256 _tokenId) public view returns (string memory) {
        string memory questId = _tokenId.toString();
        string memory name = string(abi.encodePacked('ID ', questId));
        string memory description = string(abi.encodePacked('This is a sampe NFT with Id #', questId));

        Info memory info = infos[_tokenId];
        
        return Descriptor.constructTokenURI(Descriptor.TokenURIParams({
            id: questId,
            name: name,
            description: description,
            title: info.title,
            artist: info.artist,
            status: info.status
        }));
    }
}