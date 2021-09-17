import React, { Component } from "react";
import Header from "./Components/Header/Header";
import { retrieveCookie } from "./Components/Cookies";
import Modal from "react-modal";
import MachineCard from "./Components/MachineCard/MachineCard";
import NewMachine from "./Components/Machines/NewMachine";
import { Container, Jumbotron, Row, Col, Button, Card } from "react-bootstrap";
import { useTable } from "react-table";
import DataTable, { createTheme } from "react-data-table-component";
import MachineEditor from "./Components/Machines/MachineEditor";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import "./app.css";

export default class Machines extends Component {
  constructor(props) {
    super(props);
    this.state = {
      machines: [],
      showModal: false,
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
    fetch(`http://localhost:4000/machines/getAll/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.forEach((machine) => {
          console.log(machine);
          machine.edit = (
            <Button onClick={() => this.handleOpenModal(machine.id)}>
              Edit
            </Button>
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
          },
          () => console.log()
        );
      });
  }

  renderMachines() {
    createTheme("machines", {
      text: {
        primary: "#00000",
        secondary: "#000000",
      },

      background: {
        default: "rgba(0,0,0,0)",
      },
      context: {
        background: "rgba(0,0,0,.2)",
        text: "#000000",
      },
      divider: {
        default: "rgba(0,0,0,.2)",
      },
      action: {
        button: "rgba(0,0,0,1)",
        hover: "rgba(0,0,0,.08)",
        disabled: "rgba(0,0,0,.12)",
      },
    });
    const columns = [
      {
        name: "MachineNo",
        selector: "machineNo",
        sortable: true,
      },
      {
        name: "Type",
        selector: "type",
        sortable: true,
      },
      {
        name: "Client",
        selector: "client",
        sortable: true,
      },
      {
        name: "Reports",
        selector: "reports",
        sortable: false,
      },
      {
        name: "Edit",
        selector: "edit",
        sortable: false,
      },
    ];

    return (
      <DataTableExtensions
        filterHidden={false}
        columns={columns}
        data={this.state.machines}
      >
        <DataTable
          data={this.state.machines}
          theme="machines"
          noHeader
          columns={columns}
          pagination
          subHeader
          subHeaderComponent={
            <Button onClick={() => this.handleOpenModal("new")}>
              Add Machines
            </Button>
          }
        />
      </DataTableExtensions>
    );
  }

  machineModals() {
    let modals = [];
    this.state.machines.forEach((machine) => {
      modals.push(
        <Modal
          shouldCloseOnOverlayClick
          isOpen={this.state.showModal === machine.id}
        >
          <Button variant="outline-primary" onClick={this.handleCloseModal}>
            X
          </Button>
          <br />
          <br />
          <Row>
            <Col>
              <Jumbotron>
                <Card body>
                  <MachineEditor
                    machine={machine}
                    getMachines={this.getMachines}
                  ></MachineEditor>
                </Card>
              </Jumbotron>
            </Col>
            <Col>
              <Jumbotron>
                <Card body> heheh</Card>
              </Jumbotron>
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
        <div className="body">
          <Jumbotron>
            <Modal
              shouldCloseOnOverlayClick
              isOpen={this.state.showModal === "new"}
            >
              <Button variant="outline-primary" onClick={this.handleCloseModal}>
                X
              </Button>

              <NewMachine getMachines={this.getMachines} />
            </Modal>
            <h1>Machines</h1>
            <div className="table">
              {this.machineModals()}

              {this.renderMachines()}
            </div>
          </Jumbotron>
        </div>
      </div>
    );
  }
}
