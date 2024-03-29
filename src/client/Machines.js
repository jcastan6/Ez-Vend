import React, { Component } from "react";
import Header from "./Components/Header/Header";
import { retrieveCookie } from "./Components/Cookies";
import Modal from "react-modal";

import NewMachine from "../../NewMachine";
import { Jumbotron, Row, Col, Button, Card, Container } from "react-bootstrap";

import DataTable, { createTheme } from "react-data-table-component";
import MachineEditor from "./Components/Machines/MachineEditor";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import "./app.css";
import MaintenanceLogs from "./Components/Maintenances/MaintenanceLogs";
import MaintenanceHistory from "./Components/Maintenances/MaintenanceHistory";
import MaintenanceReports from "./Components/Maintenances/MaintenanceReports";

import styled, { keyframes } from "styled-components";
const rotate360 = keyframes`
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
`;

const Spinner = styled.div`
  margin: 16px;
  animation: ${rotate360} 1s linear infinite;
  transform: translateZ(0);
  border-top: 2px solid grey;
  border-right: 2px solid grey;
  border-bottom: 2px solid grey;
  border-left: 4px solid black;
  background: transparent;
  width: 80px;
  height: 80px;
  border-radius: 50%;
`;

const CustomLoader = () => (
  <div style={{ padding: "24px" }}>
    <Spinner />
    <div>Cargando...</div>
  </div>
);

import { BsArrowLeft, BsThreeDotsVertical } from "react-icons/bs";
export default class Machines extends Component {
  constructor(props) {
    super(props);
    this.state = {
      machines: [],
      showModal: false,
      pending: true,
    };
    this.getMachines = this.getMachines.bind(this);
    this.getMachines();
    this.renderMachines = this.renderMachines.bind(this);

    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }
  getMachines() {
    this.setState({ pending: true });
    fetch(`https://www.mantenimientoscvm.com/machines/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.forEach((machine) => {
          machine.edit = (
            <BsThreeDotsVertical
              onClick={() => this.handleOpenModal(machine.id)}
            ></BsThreeDotsVertical>
          );

          if (!machine.type) {
            machine.type = "";
          } else {
            machine.type = machine.type.type;
          }

          if (!machine.client) {
            machine.client = "";
          } else {
            machine.client = machine.client.name;
          }
        });

        this.setState(
          {
            machines: res,
            showModal: false,
            pending: false,
          },
          () => console.log()
        );
      });
  }

  renderMachines() {
    const customStyles = {
      context: {
        background: "#cb4b16",
        text: "#FFFFFF",
      },
      headCells: {
        style: {
          fontSize: "14px",
        },
      },
      rows: {
        highlightOnHoverStyle: {
          backgroundColor: "rgb(230, 244, 244)",
          borderBottomColor: "#FFFFFF",
          outline: "1px solid #FFFFFF",
        },
      },
      pagination: {
        style: {
          border: "none",
        },
      },
    };
    const columns = [
      {
        name: "Numero de maquina",
        selector: "machineNo",
        sortable: true,
        style: {
          color: "#202124",
          fontSize: "14px",
          fontWeight: 500,
        },
      },
      {
        name: "Tipo",
        selector: "type",
        sortable: true,
      },
      {
        name: "Cliente",
        selector: "client",
        sortable: true,
      },
      {
        name: "Tareas Abiertas",
        selector: "reports",
        sortable: true,
      },
      {
        name: "Editar",
        selector: "edit",
        cellExport: (row) => {
          return "";
        },
        sortable: false,
        right: true,
        Button: true,
      },
    ];

    return (
      <DataTableExtensions
        filterHidden={false}
        columns={columns}
        data={this.state.machines}
      >
        <DataTable
          title="Maquinas"
          data={this.state.machines}
          customStyles={customStyles}
          columns={columns}
          pagination
          progressPending={this.state.pending}
          progressComponent={<CustomLoader />}
          onRowDoubleClicked={(row) => {
            this.handleOpenModal(row.id);
          }}
          noheader
          pointerOnHover
          highlightOnHover
        />
      </DataTableExtensions>
    );
  }

  machineModals() {
    let modals = [];
    this.state.machines.forEach((machine) => {
      modals.push(
        <Modal
          shouldCloseOnOverlayClick={true}
          onRequestClose={this.handleCloseModal}
          isOpen={this.state.showModal === machine.id}
        >
          <h4>
            <BsArrowLeft onClick={this.handleCloseModal}></BsArrowLeft>
          </h4>
          <Row>
            <Col>
              <Card body className="table">
                <MachineEditor
                  machine={machine}
                  getMachines={this.getMachines}
                ></MachineEditor>
              </Card>
            </Col>
            <Col>
              <MaintenanceLogs machine={machine}></MaintenanceLogs>
              <br></br>
              <MaintenanceReports machine={machine}></MaintenanceReports>
            </Col>

            <Col>
              <MaintenanceHistory machine={machine}></MaintenanceHistory>
            </Col>
          </Row>
        </Modal>
      );
    });
    return modals;
  }
  render() {
    return (
      <div>
        <Header></Header>
        <div className="body">
          <Container fluid>
            <Row>
              <Col lg={2}>
                <Button onClick={() => this.handleOpenModal("new")}>
                  Agregar Maquinas
                </Button>
              </Col>
              <br></br>
              <br></br>
              <Modal
                shouldCloseOnOverlayClick={true}
                onRequestClose={this.handleCloseModal}
                isOpen={this.state.showModal === "new"}
                className="modal-form"
              >
                <Card>
                  <Card.Body>
                    <NewMachine getMachines={this.getMachines} />
                  </Card.Body>
                </Card>
              </Modal>

              <Col>
                <div className="table">
                  {this.machineModals()}

                  {this.renderMachines()}
                </div>
              </Col>
            </Row>
          </Container>
        </div>
      </div>
    );
  }
}
