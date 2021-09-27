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

class MaintenanceLogs extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machine: this.props.machine,
      maintenances: [],
    };
    this.getMaintenances = this.getMaintenances.bind(this);
    this.getMaintenances();
  }

  handleRouteChange() {
    window.location.reload(false);
  }

  getMaintenances() {
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
        }),
          () => console.log();
      });
  }

  renderTasks() {
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
        cellExport: (row) => {
          return row.task;
        },
        sortable: true,
        grow: 3,
      },
      {
        name: "Days since last done",
        selector: "daysCount",
        sortable: true,
      },
      {
        name: "Past Due",
        selector: "pastDue",
        sortable: true,
      },
      {
        name: "Remind Every",
        selector: "reminderAt",
        sortable: true,
      },
      {
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
