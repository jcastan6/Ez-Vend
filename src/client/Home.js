import React, { Component } from "react";

import DataTable, { createTheme } from "react-data-table-component";
import DataTableExtensions from "react-data-table-component-extensions";
import Header from "./Components/Header/Header.js";
import "react-data-table-component-extensions/dist/index.css";
import {
  Container,
  Jumbotron,
  Row,
  Col,
  Card,
  Carousel,
} from "react-bootstrap";
import ReactTooltip from "react-tooltip";

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

export default class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
      tasks: [],
      dailyHistory: [],
      maintenancesPending: true,
      tasksPending: true,
    };
    this.getMaintenances = this.getMaintenances.bind(this);

    this.renderTasks = this.renderTasks.bind(this);
    this.getTasks = this.getTasks.bind(this);
    this.getMaintenances();
    this.getTasks();
  }
  // this.getLatest();

  getTasks() {
    this.setState({
      tasksPending: true,
    });
    fetch(
      `https://www.mantenimientoscvm.com/machines/getAllMaintenanceLogsHome/`,
      {
        method: "GET",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((res) => {
        this.setState({
          tasksPending: false,
          tasks: res,
        });
      });
  }

  getMaintenances() {
    this.setState({
      maintenancesPending: true,
    });
    fetch(
      `https://www.mantenimientoscvm.com/machines/getDailyMaintenanceHistory/`,
      {
        method: "GET",
        credentials: "same-origin",
      }
    )
      .then((response) => response.json())
      .then((res) => {
        console.log(JSON.stringify(res));
        this.setState({
          dailyHistory: res,
          maintenancesPending: false,
        }),
          () => console.log();
      });
  }

  renderTasks() {
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
        name: "Numero de Maquina",
        selector: "vendingMachine.machineNo",
        sortable: true,
      },
      {
        name: "Tarea",
        cell: (row) => {
          return <div data-tip={row.task}>{row.task}</div>;
        },
        sortable: false,
      },
      {
        name: "Cliente",
        cell: (row) => {
          if (row.client) {
            return row.client.name;
          } else {
            return "";
          }
        },
        sortable: true,
      },
      {
        name: "Tipo de Mantenimiento",
        cell: (row) => {
          if (row.emergency) {
            return "Correctivo";
          } else {
            return "Preventivo";
          }
        },

        conditionalCellStyles: [
          {
            when: (row) => row.emergency,
            style: {
              backgroundColor: "rgba(255, 0, 0, 0.3)",
            },
          },
        ],
      },
    ];
    return (
      <Card body className="table">
        <Card.Title>Tareas Abiertas</Card.Title>
        <DataTableExtensions
          filterHidden={false}
          columns={columns}
          data={this.state.tasks}
        >
          <DataTable
            data={this.state.tasks}
            progressPending={this.state.tasksPending}
            progressComponent={<CustomLoader />}
            noHeader
            columns={columns}
            pagination
            customStyles={customStyles}
            highlightOnHover
          />
        </DataTableExtensions>
      </Card>
    );
  }
  renderDailyTasks() {
    const columns = [
      {
        name: "Numero de Maquina",
        selector: "machineNo",
        sortable: true,
      },
      {
        name: "Tarea",
        cell: (row) => {
          return (
            <div data-tip={row.task}>
              {row.task} <ReactTooltip />
            </div>
          );
        },
        sortable: true,

        allowOverflow: true,
      },

      {
        name: "Fecha",
        selector: "createdAt",
        sortable: true,
      },
      {
        name: "Realizado Por:",
        selector: "employee",
        sortable: true,
      },
    ];
    return (
      <Card body className="table">
        <Card.Title>Mantenimientos Hechos Hoy</Card.Title>
        <DataTableExtensions
          filterHidden={false}
          columns={columns}
          data={this.state.dailyHistory}
        >
          <DataTable
            data={this.state.dailyHistory}
            noHeader
            progressPending={this.state.maintenancesPending}
            progressComponent={<CustomLoader />}
            theme="machines"
            columns={columns}
            pagination
            highlightOnHover
          />
        </DataTableExtensions>
      </Card>
    );
  }
  render() {
    return (
      <div>
        <Header />
        <Jumbotron>
          <Container>
            <Row>
              <Col>{this.renderTasks()}</Col>
              <Col>{this.renderDailyTasks()}</Col>
            </Row>
          </Container>
        </Jumbotron>
      </div>
    );
  }
}
