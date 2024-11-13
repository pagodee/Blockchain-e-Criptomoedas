// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define o contrato Eleicao (Eleição)
contract Eleicao {
    
    // Define uma struct para representar um candidato
    struct Candidato {
        uint id;           // Identificador único para o candidato
        string nome;       // Nome do candidato
        uint votos;        // Número de votos que o candidato recebeu
    }

    // Mapeamento do ID do candidato para a struct Candidato
    mapping(uint => Candidato) public candidatos;
    
    // Número total de candidatos adicionados à eleição
    uint public totalCandidatos;
    
    // Mapeamento para rastrear se um endereço já votou
    mapping(address => bool) public votantes;

    // Evento a ser emitido quando um voto é registrado
    event VotoRegistrado(uint indexed candidatoId);

    // Construtor executado uma vez quando o contrato é implantado
    constructor() {
        // Adiciona candidatos iniciais à eleição
        adicionarCandidato("Alice");
        adicionarCandidato("Bob");
    }

    /**
     * @dev Adiciona um novo candidato à eleição.
     * @param _nome O nome do candidato a ser adicionado.
     *
     * Esta função é marcada como privada, o que significa que só pode ser chamada
     * de dentro do próprio contrato. Ela incrementa o número total de
     * candidatos e cria uma nova struct Candidato no mapeamento candidatos.
     */
     
    function adicionarCandidato(string memory _nome) private {
        totalCandidatos++; // Incrementa o número total de candidatos
        candidatos[totalCandidatos] = Candidato(totalCandidatos, _nome, 0); // Adiciona o novo candidato
    }

    /**
     * @dev Permite que um usuário vote em um candidato.
     * @param _candidatoId O ID do candidato para o qual votar.
     *
     * Requisitos:
     * - O remetente não deve ter votado antes.
     * - O ID do candidato deve ser válido (isto é, existir no mapeamento candidatos).
     *
     * Esta função marca o remetente como tendo votado, incrementa a
     * contagem de votos para o candidato especificado e emite um evento VotoRegistrado.
     */
    function votar(uint _candidatoId) public {
        // Garante que o remetente ainda não votou
        require(!votantes[msg.sender], "Voce ja votou.");
        
        // Garante que o ID do candidato é válido
        require(_candidatoId > 0 && _candidatoId <= totalCandidatos, "Candidato invalido.");

        votantes[msg.sender] = true; // Marca o remetente como tendo votado
        candidatos[_candidatoId].votos++; // Incrementa a contagem de votos do candidato

        emit VotoRegistrado(_candidatoId); // Emite o evento de voto registrado
    }

    /**
     * @dev Recupera o número de votos que um candidato recebeu.
     * @param _candidatoId O ID do candidato.
     * @return O número de votos que o candidato tem.
     *
     * Requisitos:
     * - O ID do candidato deve ser válido.
     */
    function getVotos(uint _candidatoId) public view returns (uint) {
        // Garante que o ID do candidato é válido
        require(_candidatoId > 0 && _candidatoId <= totalCandidatos, "Candidato invalido.");
        
        return candidatos[_candidatoId].votos; // Retorna a contagem de votos
    }
}
