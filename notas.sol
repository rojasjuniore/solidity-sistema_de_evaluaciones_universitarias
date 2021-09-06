// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5

contract notas {
    // direcciones del profesor
    address public profesor;

    // Construtor
    constructor() public {
        profesor = msg.sender;
    }

    // Mapping de notas para relaciona  el hash de la identidad con su nota del examen
    mapping(bytes32 => uint256) public Notas;

    // array de los alumnos que pidan revisiones de examen
    string[] revisiones;

    // Eventos
    event alumnos_evaludado(bytes32, uint256);
    event eventos_revision(string);

    // Funcion para evaluar las notas de los alumnos
    function Evaluar(string memory _idAlumno, uint256 _nota)
        public
        UnicamenteProfesor(msg.sender)
    {
        // has de la identidicacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));

        // Relaccion entre hash de la identifiacion del alumno y la nota
        Notas[hash_idAlumno] = _nota;

        // Emision de evento nuevo alumno evaluado
        emit alumnos_evaludado(hash_idAlumno, _nota);
    }

    // este es un control para las funciones ejecutables por el profesor
    modifier UnicamenteProfesor(address _direccion) {
        // requiere que el profesor sea el que lo pide
        require(
            _direccion == profesor,
            "No tienes permisos para ejecutar esta funcion, no eres un profesor"
        );
        _;
    }

    // funcion para ver las notas de un alumno de clase

    function VerNotas(string memory _idAlumno) public view returns (uint256) {
        // hash de la identidicacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));

        // notas asociadas al alumno.
        uint256 nota_alumno = Notas[hash_idAlumno];

        // visualizacion de notas
        return nota_alumno;
    }

    // Funcion para pedir una revision d eu examne
    function Revision(string memory _idAlumno) public {
        // Almacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);

        // Emitir un evento
        emit eventos_revision(_idAlumno);
    }

    // fucnion para ver los alumnos que han soliciddos revisiones de los examen
    function VerRevisiones()
        public
        view
        UnicamenteProfesor(msg.sender)
        returns (string[] memory)
    {
        // devolver las identidades de los alumons que han solicitados revisioones
        return revisiones;
    }
}
