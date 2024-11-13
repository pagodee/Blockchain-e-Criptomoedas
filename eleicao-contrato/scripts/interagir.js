const hre = require("hardhat");

async function main() {
  // Compila os contratos se ainda não foram compilados
  await hre.run('compile');

  // Implanta o contrato
  const Eleicao = await hre.ethers.getContractFactory("Eleicao");
  const eleicao = await Eleicao.deploy();

  await eleicao.deployed();
  console.log("Contrato implantado em:", eleicao.address);

  // Vota no candidato 1
  let tx = await eleicao.votar(1);
  await tx.wait();
  console.log("Votou no candidato 1");

  // Exibe votos do candidato 1
  let votosCandidato1 = await eleicao.getVotos(1);
  console.log("Votos do candidato 1:", votosCandidato1.toString());

  // Tenta votar novamente com o mesmo endereço
  try {
    tx = await eleicao.votar(2);
    await tx.wait();
  } catch (error) {
    console.log("Erro ao votar novamente:", error.message);
  }

  // Consulta votos do candidato 2
  let votosCandidato2 = await eleicao.getVotos(2);
  console.log("Votos do candidato 2:", votosCandidato2.toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
