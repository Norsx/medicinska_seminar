# A cascaded force/position hybrid control method based on ultrasound robots

* **ID:** H3
* **Authors:** Guoan Chen, Yongxuan Wang, Hang Su, Rong Liu
* **Year:** 2025
* **DOI:** https://doi.org/10.1109/icia64617.2025.11277546
* **Original Query:** A cascaded force/position hybrid control method based on ultrasound robots

## Abstract
In the ultrasound robot automatic scanning, the robot needs to maintain a stable contact force in the scanning normal direction to ensure image quality, while maintaining a safe human-computer interaction force in other directions. Therefore, achieving stable and safe contact force control and accurate position tracking has become a key challenge in complex environments. Therefore, this paper proposes a cascaded force/position hybrid control method to overcome the problem that it is difficult for traditional force/position hybrid control to balance accuracy and safe interaction in dynamic environments, especially the risk of force control failure in scenarios such as sudden shedding. Firstly, the median filter is dynamically compensated to suppress the noise of the force sensor in real time and eliminate the interference of the Coriolis force to improve the performance of the force signal. Then, the task space is decomposed into tangential and normal directions, Cartesian impedance control is used in the tangential direction to achieve compliant position tracking, and the cascaded force control strategy of impedance feedforward and PID feedback is fused in the normal direction to improve the force control performance. In addition, strict null-space projection is introduced to optimize redundant degrees of freedom and significantly reduce joint fluctuations. The abdominal phantom force tracking experiment shows that compared with the pure PID control, the proposed method reduces the standard error of the mean force by 24.53%, the fluctuation is smaller, the maximum contact force is reduced by 4.15%, the interaction safety is higher, and the impedance compensation force can effectively deal with the sudden detachment scene. Finally, high-precision force tracking is achieved in planar, curved and abdominal phantom scanning, which shows the effectiveness and reliability of the method.

## Summary and Conclusions
This paper addresses the design, methodology, and implementation of robotic ultrasound control. It introduces techniques to improve force regulation, visual tracking, or safety systems. Detailed analysis demonstrates the effectiveness of the proposed approaches in medical robotics.
