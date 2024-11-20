// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Eleicao {
    
    // Define uma struct para representar um candidato
    struct Candidato {
        uint id;           
        string nome;       
        uint votos;        
    }

    mapping(uint => Candidato) public candidatos;
    
    uint public totalCandidatos;
    
    mapping(address => bool) public votantes;

    event VotoRegistrado(uint indexed candidatoId);

    constructor() {
        adicionarCandidato("Alice");
        adicionarCandidato("Bob");
    }

    
     
    function adicionarCandidato(string memory _nome) private {
        totalCandidatos++; 
        candidatos[totalCandidatos] = Candidato(totalCandidatos, _nome, 0); 
    }

    
    function votar(uint _candidatoId) public {
        
        require(!votantes[msg.sender], "Voce ja votou.");
        
        
        require(_candidatoId > 0 && _candidatoId <= totalCandidatos, "Candidato invalido.");

        votantes[msg.sender] = true; 
        candidatos[_candidatoId].votos++; 

        emit VotoRegistrado(_candidatoId); 
    }

    
    function getVotos(uint _candidatoId) public view returns (uint) {
        require(_candidatoId > 0 && _candidatoId <= totalCandidatos, "Candidato invalido.");
        
        return candidatos[_candidatoId].votos; 
    }
}
