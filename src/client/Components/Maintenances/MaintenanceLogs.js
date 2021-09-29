import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";

import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Card,
  Carousel,
} from "react-bootstrap";
import ReactTooltip from "react-tooltip";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";
import NewMaintenance from "./NewMaintenance";
import TaskEditor from "./TaskEditor";

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

class MaintenanceLogs extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machine: this.props.machine,
      maintenances: [],
      pending: true,
    };
    this.getMaintenances = this.getMaintenances.bind(this);
    this.getMaintenances();
  }

  handleRouteChange() {
    window.location.reload(false);
  }

  getMaintenances() {
    this.setState({ pending: true });
    const get = {};
    get.machine = this.state.machine;
    fetch(`https://www.mantenimientoscvm.com/machines/getMaintenanceLogs/`, {
      body: JSON.stringify(get),
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState({
          maintenances: res,
          pending: false,
        }),
          () => console.log();
      });
  }

  renderTasks() {
    const columns = [
      {
        name: "Tarea",
        cell: (row) => {
          return (
            <div data-tip={row.task}>
              {row.task} <ReactTooltip />
            </div>
          );
        },
        cellExport: (row) => {
          return row.task;
        },
        sortable: true,
        grow: 3,
      },
      {
        name: "Dias desde ultimo mantenimiento:",
        selector: "daysCount",
        sortable: true,
      },
      {
        name: "Vencido",
        selector: "pastDue",
        sortable: true,
      },
      {
        name: "Recordar cada:",
        selector: "reminderAt",
        sortable: true,
      },
      {
        name: "Editar:",
        selector: "edit",
        cell: (row) => (
          <TaskEditor task={row} getMaintenances={this.getMaintenances} />
        ),
        right: true,
        button: true,
      },
    ];
    return (
      <Card body className="table">
        <NewMaintenance
          machine={this.props.machine}
          getMaintenances={this.getMaintenances}
        ></NewMaintenance>
        <DataTableExtensions
          filterHidden={false}
          columns={columns}
          data={this.state.maintenances}
        >
          <DataTable
            data={this.state.maintenances}
            noHeader
            theme="machines"
            columns={columns}
            progressPending={this.state.pending}
            progressComponent={<CustomLoader />}
            pagination
            highlightOnHover
          />
        </DataTableExtensions>
      </Card>
    );
  }

  render() {
    return <div>{this.renderTasks()}</div>;
  }
}
export default withRouter(MaintenanceLogs);
