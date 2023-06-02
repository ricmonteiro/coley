/*import React from 'react'
import { Form, Button } from 'react-bootstrap'
import { useNavigate, useLocation } from 'react-router-dom';
import { useEffect, useState} from 'react';
import axios from 'axios'


function CreateCut() {
  const navigate = useNavigate();
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const isLogged = location.state && location.state.isLogged
  const authUser = location.state && location.state.authUser

  const [samples, setSamples] = useState([])
  const [availableCuts, setAvailableCuts] = useState([])
  const [error, setError] = useState('')

  const [selectedSample, setSelectedSample] = useState('')
  const [selectedDate, setSelectedDate] = useState('')

  const [selectedCut, setSelectedCut] = useState('')


  useEffect(() => { 
    if(isLogged){
      axios.get('/samples').then(resp => {
      setSamples(resp.data.data)
  });
  }else{navigate('/')}},[navigate])

  const handleChangeSample = (event) => {
    setSelectedSample(event.target.value)

  }

  useEffect(()=> {
    console.log(selectedSample)

    axios.get("/cuts_from_sample", { params: { sample: selectedSample } })
    .then((response) => {

      setAvailableCuts(response.data.data)
      
    }
    ).catch((error) => {

      console.error(error);
      setError("An error occurred while retrieving the available cuts");

    });

  },[selectedSample])


  console.log(availableCuts)
  console.log(samples)

  const handleCutsAvailable = (event) => {
    console.log(event.target.value)
  }

  const handleChangeCut = (event) => {
    console.log(event.target.value)
  }

  const handleCancel = (event) => {
    navigate('/dashboard', { state : { isLogged, selectedRole, authUser }})
  }

  const handleChangePurpose = (event) =>  {
    console.log(event.target.value)
  }

  const handleChangeDate = (event) => {
    console.log(event.target.value)
  }

  return (
    <Form>
        <h1>Create a cut from a sample</h1>

        <Form.Label>Select sample
        <Form.Select
        value={selectedSample}
        onChange={handleChangeSample}>
        <option value="" disabled>Select sample</option>
        {samples.map((sample) => {
        return (
          <option key={sample["0"]["id"]} value={sample["0"]["id"]}>sample id: {sample["0"]["id"]}, origin: {sample["0"]["origin"]}, from {sample["0"]["entry_date"]}</option>
        );
      })}
    </Form.Select>
    </Form.Label>


    

    <Form.Label>Purpose</Form.Label>
      <Form.Control
        type="text"
        onChange={handleChangePurpose}
      />

      <Form.Label>Select date</Form.Label>
        <Form.Control type="date" value={selectedDate} name="entry-date" placeholder="Date of Birth" onChange={handleChangeDate} />  

    <Button className='button m-2' type='Submit'>Create cut</Button>
    <Button  className='button m-2' style={{ backgroundColor: "black" }} onClick={handleCancel}>Back</Button>
    </Form>
  )
}

export default CreateCut;*/