pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "./SafeMath.sol";
import "./BytesLib.sol";
import "./Merkle.sol";

contract VerifierContract {
    using SafeMath for uint;
    using BytesLib for bytes;
    using Merkle for bytes32;

    struct Proof {
        bytes32 root;               // merkle root of P, D and B - evaluations 
        bytes32 lRoot;              // merkle root of L - evaluations
        bytes[] branches;           // branches of P, D and B - evaluations
        FriComponent friComponent;  // low-degree proofs
    }

    struct FriComponent {
        bytes32 root;      // merkle root of columns
        bytes[] branches;  // branches of the column and the four values in the polynominal
    }

    uint constant MODULUS = 2 ** 256 - 2 ** 32 * 351 + 1;
    uint constant SPOT_CHECK_SECURITY_FACTOR = 80;
    uint constant EXTENSION_FACTOR = 8;


    // verify an FRI proof
    function verifyLowDegreeProof(
        bytes32 _merkleRoot, 
        uint _rootOfUnity, 
        FriComponent[] _friComponents, 
        uint _maxDegPlus1, 
        uint _modulus, 
        uint _excludeMultiplesOf
    ) public returns (bool) 
    {
        return false;
    }

    // verify a STARK
    function verifyMimcProof(
        uint _input, 
        uint _steps, 
        uint[] _roundConstants, 
        uint _output, 
        Proof _proof
    ) public returns (bool) 
    {
        bytes32 root = _proof.root;
        bytes32 lRoot = _proof.lRoot;
        bytes[] memory branches = _proof.branches;
        FriComponent memory friComponent = _proof.friComponent;

        require(_steps <= 2 ** 32);
        // require(isPowerOf2(steps) && isPowerOf2(_roundConstants.length));
        require(_roundConstants.length < _steps);

        uint precision = _steps.mul(EXTENSION_FACTOR);
        uint G2 = (7 ** ((MODULUS - 1).div(precision))) % MODULUS;
        uint skips = precision.div(_steps);
        uint skips2 = _steps.div(_roundConstants.length);
        
        // uint[] constantsMiniPolynomial =
        // require(verifyLowDegreeProof(bytes32 lRoot, uint G2, FriComponent friComponent, uint _steps * 2, uint MODULUS, uint EXTENSION_FACTOR));

        uint k1 = uint(keccak256(abi.encodePacked(root, 0x01)));
        uint k2 = uint(keccak256(abi.encodePacked(root, 0x02)));
        uint k3 = uint(keccak256(abi.encodePacked(root, 0x03)));
        uint k4 = uint(keccak256(abi.encodePacked(root, 0x04)));

        uint[] positions = getPseudoramdomIndicies(lRoot, precision, SPOT_CHECK_SECURITY_FACTOR, EXTENSION_FACTOR);
        uint lastStepPosition = (G2 ** ((steps - 1).mul(skips))) % MODULUS;

        for (uint i; i < positions.length; i++) {
            uint x = (G2 ** positions[i]) % MODULUS;
            uint xToTheSteps = (x ** _steps) % MODULUS;

            // a branch check for P, D and B
            bytes memory mBranch1 = root.verifyBranch(positions[i], branches[i * 3]);
            // a branch check for P of g1x
            bytes memory mBranch2 = root.verifyBranch((positions[i].add(skips)) % precision, branches[i * 3 + 1]);
            // a branch check for L
            uint lx = uint(root.verifyBranch(positions[i], branches[i * 3 + 2]));

            uint px = mBranch.slice
            uint pG1x = 
            uint dx = 
            uint bx = 
        }

        return true;
    }

    function getPseudorandomIndices() internal returns (uint[]) {

    }

}
