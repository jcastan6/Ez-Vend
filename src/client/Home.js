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

export default class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
      tasks: [],
      dailyHistory: [],
    };
    this.getMaintenances = this.getMaintenances.bind(this);

    this.renderTasks = this.renderTasks.bind(this);
    this.getTasks = this.getTasks.bind(this);
    this.getMaintenances();
    this.getTasks();
  }
  // this.getLatest();

  getTasks() {
    fetch(`https://www.mantenimientoscvm.com/machines/getAllMaintenanceLogs/`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState({
          tasks: res,
        });
      });
  }

  getMaintenances() {
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
        name: "MachineNo",
        selector: "vendingMachine.machineNo",
        sortable: true,
      },
      {
        name: "Task",
        cell: (row) => {
          return <div data-tip={row.task}>{row.task}</div>;
        },
        sortable: false,
      },
      {
        name: "Client",
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
        name: "Type",
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
        <Card.Title>Open Tasks</Card.Title>
        <DataTableExtensions
          filterHidden={false}
          columns={columns}
          data={this.state.tasks}
        >
          <DataTable
            data={this.state.tasks}
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
        name: "Task",
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
        name: "Date",
        selector: "createdAt",
        sortable: true,
        grow: 3,
      },
      {
        name: "Completed by",
        selector: "employee",
        sortable: true,
      },
    ];
    return (
      <Card body className="table">
        <Card.Title>Today's Maintenances</Card.Title>
        <DataTableExtensions
          filterHidden={false}
          columns={columns}
          data={this.state.dailyHistory}
        >
          <DataTable
            data={this.state.dailyHistory}
            noHeader
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
