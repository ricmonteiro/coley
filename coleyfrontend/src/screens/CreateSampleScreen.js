import React from 'react'
import { useNavigate, useLocation } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { Form, Button, Row, Col} from 'react-bootstrap'
import axios from 'axios'


function CreateSample() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const [loading, setLoading] = useState('')
  const [error, setError] = useState('')
  const [patientList, setPatientList] = useState([])
  const [tissueTypes, setTissueTypes] = useState([])
  
  const [selectedPatient, setSelectedPatient] = useState('')
  const [selectedTissue, setSelectedTissue] = useState('')
  const [selectedDate, setSelectedDate] = useState(new Date());


 
 
  /*Sample states */
  useEffect(() => {
    if(isLogged){
    setLoading(true)

  /*Get patients*/
    axios.get("/patient_list/")
    .then((response1) => {
      setPatientList(response1.data.data);
      setLoading(false)}
    )
    .catch((error1) => {
      setError("An error occurred while retrieving the patients.");
      console.error(error1);
    });
    
  /*Get tissues*/
    setLoading(true)
    axios.get("/tissuetypes/")
    .then((response2) => {
      setTissueTypes(response2.data.data)
      setLoading(false)
      console.log(response2.data.data)}
    )
    .catch((error2) => {
      setError('An error occurred while retrieving the tissue types.')
      console.log(error2)
    })}
    else{navigate('/')}}, [navigate, isLogged, selectedRole]);
  
  const handleSubmit = (event) => {

      event.preventDefault();
      console.log(event.target.value)
    /*user_id, origin, patient_id, tumor_type_id, tissue_type_id, entry_date, 
    # temperature_id, container_id, "location"*/
      var formData = {
        selectedPatient: selectedPatient,
        selectedTissue: selectedTissue,
        selectedDate: selectedDate
        };
    }

    const handleCancel = (event) => {
      navigate('/dashboard', { state : { isLogged, selectedRole }})
    }

    const handleChangePatient = (event) => {
      setSelectedPatient(event.target.value)
      console.log(event.target.value)
    }

    const handleChangeTissue = (event) => {
      setSelectedTissue(event.target.value)
      console.log(event.target.value)
    }    

    const handleChangeDate = (event) => {
      setSelectedDate(event.target.value)
      
      console.log(event.target.value)
    }
      return (
        <Form>
          {loading}
          <Form.Label>Select patient
          <Form.Select
        value={selectedPatient}
        onChange={handleChangePatient}
        >
        <option value="" disabled selected>Select patient</option>
        {patientList.map((patient) => {
        return (
          <option key={patient["0"]["id"]} value={patient["0"]["id"]}>{patient["0"]["id"]} - {patient["0"]["patient_name"]}</option>
        );
      })}
        </Form.Select>
        </Form.Label>

        <Form.Label htmlFor="inputPassword5">Origin</Form.Label>
      <Form.Control
        type="text"
      />

        <Form.Label>Select tissue type
          <Form.Select
          value={selectedTissue}
          onChange={handleChangeTissue}>
            <option value="" disabled selected>Select tissue</option>
            {tissueTypes.map((tissue) => {
              return (
                <option key={tissue["0"]["id"]} value={tissue["0"]["tissue_description"]}>{tissue["0"]["tissue_description"]}</option>
              );
            })}
                     

        </Form.Select>
        </Form.Label>
      

        <Form.Label>Select date</Form.Label>
        <Form.Control type="date" value={selectedDate} name="entry-date" placeholder="Date of Birth" onChange={handleChangeDate} />  

          {error && <p>{error}</p>}
          <Button className='button m-2' disabled={!selectedRole} onClick={handleSubmit}>Register patient</Button>
          <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
        </Form>
      );
}

export default CreateSample