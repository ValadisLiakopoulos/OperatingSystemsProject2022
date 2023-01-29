//Necessary libraries
#include <stdio.h> //Used for standard I/O.
#include <stdlib.h> //Used for exit().
#include <sys/ipc.h>//Used for message queue.
#include <sys/msg.h>//Used for message queue.
#include <math.h> //Used for sqrt and log functions.
#include <sys/time.h>//Used for time calculations.
#include <unistd.h>//Used for getpid(),sleep(),fork() etc.
#include <sys/wait.h>//Used for waitpid().
#include <string.h>//Used for argument handling (strcmp()).

#define MAXPROC 255


void startOutput(void){ //Starting output as function for cleaner code.
    printf("Welcome to integral log(x)*sqrt(x) calculator !\n");
    fflush(stdout);
    sleep(1);
    printf("You can access anytime History.log to monitor results.\n");
    fflush(stdout);
    sleep(1);
    printf("To enable child creation info run with -info parameter.\n");
    fflush(stdout);
}

struct msg_buffer{ //Structure of the message buffer.
    long int msg_type;
    double msg_data[MAXPROC];
};

struct msg_buffer message; //Initialize global message buffer.

double get_wtime(void){ //Function for timestamps.
    struct timeval t;
    gettimeofday(&t, NULL);
    return (double)t.tv_sec + (double)t.tv_usec*1.0e-6;
}

double f(double x){ //F function used for calculation of log*sqrt.
       return log(x)*sqrt(x);
}

void proc_calc(int ifk,int msgid, int procn,double a, double b){ //Child process function.
    unsigned long const n = 1e9;//Every process calculates a part of the result for quicker solving times
    const double dx = (b-a)/n;
    double S = 0;

    for (unsigned long i = ifk; i < (n); i+=procn) { //i+=process_number for division of the total addition.
         double xi = a + (i + 0.5)*dx;
            S += f(xi);
    }
            S *= dx;
    message.msg_data[ifk]=S; //Getting message ready
    if((msgsnd(msgid, &message, sizeof(message), 0))==-1){ //Sending message/if message failed print failure
        printf("Child process: %d didn't send message.",getpid());
    }
}

int main(int argc, char *argv[]){
    int infov=0,proc_num,msgid,deflt=0; //Initialize necessary integers(flags,variable for processes,queue id)
    double lowerl=0,upperl=0; //Initialize double variables for integration limits
    char str1[5]="-info"; //String for strcmp of arguments
    char str2[8]="-custom"; // ----"---"-----
    double t0=0; //Timestamp variable for measuring time taken.
    pid_t pid; // Pid variable for creating child processes
    key_t key;//key variable for getting message queue key

program_start: //Label for program's starting point for goto use
    system("clear"); //Clear the screen

    //Block that checks given arguments. Made like this due to segmentation fault problems with strcmp.
    for(int i=1; i<argc; i++){
        if(argv[i]!=NULL && strcmp(argv[i],str1)==0){ //Checks for -info on arguments
            infov=1;
        }
    }
    key=ftok("progfile",65); //Getting unique key for message queue

    msgid = msgget(key, 0666 | IPC_CREAT); //Creating message queue and getting the ID

    if(msgid==-1){ //If message queue=-1:Message queue creation failed.Save the incident to History.log
        printf("Message queue not initialized.\n");
        system("timestamp=$(date +%d-%m-%Y_%H-%M-%S) && echo $timestamp>>History.log");
        system("echo Failed to initialize message queue.>>History.log");
        system("echo $'\n'>>History.log");
        return 1;
    }

    message.msg_type=1; //Setting message type


    startOutput(); //Call starting output function
        printf("\nGive number of processes(MAX=255): ");
        scanf("%d", &proc_num);
        lowerl=1;
        upperl=4;

if(proc_num>255 || proc_num<1){ //Max 255 processes due to MacOS message queue size of: 2048 bytes.
    printf("Given value of processes is not valid.\n"); //If value for processes not valid print and save incident
    system("timestamp=$(date +%d-%m-%Y_%H-%M-%S) && echo $timestamp>>History.log");
    system("echo Given value of processes not valid. >>History.log");
    system("echo $'\n'>>History.log");
    goto program_end; //Goto program selection for user's decision of continuing
}


    t0=get_wtime(); //Starting timestamp to use for time calculation

    for(int ifork=0; ifork<proc_num; ifork++){ //Loop for process creation

        pid=fork();
        if( pid == 0 ){
            if(infov==1){ //If user used -info then he will notified for children creation and pid
                printf("Child process: %d created,parent process: %d.\n", getpid(),getppid()); //return creation info
            }
            proc_calc(ifork, msgid, proc_num, lowerl, upperl); //call function to calculate result
            exit(0); //Child process Exits. Remaining code executes only by parent process.
        }
    }

    double result=0,t1=0; //Initialize t1 and result

    while((pid = waitpid(-1, NULL, 0) > 0)){ //As parent waits for children, receive message and calculate result
        msgrcv(msgid, &message,sizeof(message),1, 0);

        for(int resc=0; resc<proc_num; resc++){ //Calculate result for every message that receives from children processes
            result+=message.msg_data[resc];
        }
    }
    t1 = get_wtime(); //Get last timestamp
    printf("\nResult=%.8f\n",result); //Print result

    if(t1-t0<2){ //If statement that checks how the machine handled the math problem.Print if time is good or not
        printf("Time taken = %lf (Good time).\n",t1-t0);//Very good time
    }else if(t1-t0<4){
        printf("Time taken = %lf (Average time).\n",t1-t0);//Good/average time
    }else{
        printf("Time taken = %lf (Not ideal time).\n",t1-t0);//Not ideal time(machine is slow)
    }

    char valuebuf[200],resbuf[200],procbuf[200],parambuff[200];//Create buffers for saving results
    //Block of code for saving results to History.log
    system("timestamp=$(date +%d-%m-%Y_%H-%M-%S) && echo $timestamp>>History.log");
    system("echo Parameters used: >>History.log");//(1) Parameters used.
    sprintf(valuebuf,"echo Range of integral: %.4f - %.4f>>History.log ", lowerl, upperl);
    sprintf(procbuf,"echo Number of children processes: %d, Parent process ID: %d. >> History.log",proc_num,getpid());
    sprintf(resbuf,"echo Result: %.8f, Time taken: %lf.>>History.log", result, t1-t0);
    for(int i=1; i<argc; i++){
        sprintf(parambuff,"echo %s >>History.log",argv[i]);
        system(parambuff);
    }
    if(argc==1){ //If user didnt use parameters save NULL to parameters used*(1)*.
        system("echo NULL >> History.log");
    }
    system(procbuf);
    system(valuebuf);
    system(resbuf);
    system("echo $'\n'>>History.log");
    //end of saving block

program_end: //Label for last part of code.Deletes the message queue and lets user to decide if they want to restart.
    msgctl(msgid, IPC_RMID, NULL);

    for(int i=0;i<256;i++){ //Clears the message buffer
        message.msg_data[i]=0;
    }

    char selection=1; //Selection character for getchar use

    printf("\nDo you want to restart?(Y/n): ");

    while(selection!='Y' && selection!='y' && selection!='n' && selection!='N'){ //Only exits with correct input
        selection=getchar();
    }

    if(selection=='y' || selection=='Y'){ //If user decide for restart go to program_start label
        printf("\nRestarting");
        for(int i=0; i<3; i++){
            printf(".");
            fflush(stdout);
            usleep(500000);
        }
        system("clear");
        goto program_start;
    }
    //Ending message and exiting.
    char gdb[8]={'G','o','o','d','b','y','e','!'};
    system("clear");
    for(int i=0; i<8; i++){
        printf("%c", gdb[i]);
        fflush(stdout);
        usleep(200000);
    }
    fflush(stdout);
    usleep(350000);
    system("clear");
    return 0;
}

