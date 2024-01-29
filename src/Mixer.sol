// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
pragma solidity ^0.8.20;

contract Mixer {
    uint256 public rootId;
    mapping(address => uint256) private _depoistMap;

    error NOT_ENOUGH_DEPOSIT(address, uint256); // 存款不足

    event UpdateSuccess(); // 更新成功
    event DepositSuccess(); // 存款成功
    event WithdrawSuccess(); // 取款成功

    function updateRootId(uint256 _rootId) external {
        rootId = _rootId;
        emit UpdateSuccess();
    }

    // 用户存款
    function deposit() external payable {
        _depoistMap[msg.sender] += msg.value;
        emit DepositSuccess();
    }

    function withdraw(uint256 _amount) external {
        if (_amount > _depoistMap[msg.sender]) {
            revert NOT_ENOUGH_DEPOSIT(msg.sender, _amount);
        }

        require(_amount > 0, "Refund amount must be greater than 0");
        require(_amount <= _depoistMap[msg.sender], "Insufficient balance for refund");
        payable(msg.sender).transfer(_amount);
        _depoistMap[msg.sender] -= _amount;
        emit WithdrawSuccess();
    }

    function _getHash(address _address1, address _address2)
        internal
        pure
        returns (bytes32)
    {
        bytes32 hash = keccak256(abi.encodePacked(_address1, _address2));
        return hash;
    }
}
